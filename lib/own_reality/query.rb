class OwnReality::Query

  def get(type, id)
    response = elastic.request "get", "#{type}/#{id}"
    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end  
  end

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def config
    @config ||= elastic.request("get", "config/complete").last['_source']
  end

  def paper(type, id)
    unless ["sources", "magazines", "articles", "interviews"].include?(type)
      raise "unknown type #{type.inspect}"
    end

    response = elastic.request "get", "#{type}/#{id}"

    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end    
  end

  def papers(type = nil, criteria = {})
    unless ["magazines", "articles", "interviews"].include?(type)
      raise "unknown type #{type.inspect}"
    end

    criteria ||= {}
    criteria["page"] = (criteria["page"] || 1).to_i
    criteria["per_page"] = (criteria["per_page"] || 10).to_i

    response = elastic.request "post", "#{type}/_search", nil, {
      "size" => criteria["per_page"],
      "from" => (criteria["page"] - 1) * criteria["per_page"],
      "sort" => ["title.de"]
    }

    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end
  end

  def people(criteria = {})
    criteria['terms'] ||= ''

    data = {
      'query' => {
        'query_string' => {
          'query' => criteria['terms'],
          'default_operator' => 'AND',
          'analyzer' => 'folding',
          'analyze_wildcard' => true,
          'fields' => [
            # 'id^50',
            'last_name^10',
            'first_name^10'
          ]
        }
      }
    }

    Rails.logger.debug data.inspect

    response = elastic.request "post", "people/_search", nil, data

    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end
  end

  def search(type, criteria = {})
    criteria ||= {}
    criteria["page"] = (criteria["page"] || 1).to_i
    criteria["per_page"] = (criteria["per_page"] || 10).to_i

    search_type = criteria['search_type'] || 'query_then_fetch'

    aggs = {
      "attr.4.2" => {
        "terms" => {
          "field" => "attrs.ids.4.2",
          "size" => 4
        }
      }
    }

    config["categories"].each_with_index do |data, id|
      aggs[id] = {
        "terms" => {
          # "script" => "doc['refs']['#{c}'].values",
          "field" => "attrs.by_category.#{id}",
          # "lang" => "groovy",
          "size" => 5
        }
      }

      if criteria["refs"]
        aggs[id]["terms"]["exclude"] = criteria["refs"]
      end
    end

    unless type.present?
      aggs['type'] = {
        'terms' => {
          'field' => '_type',
          'size' => 10
        }
      }
    end

    data = {
      "aggs" => aggs,
      "query" => {
        "bool" => {
          "must" => []
        }
      },
      "size" => (search_type == 'count' ? 0 : criteria["per_page"]),
      "from" => (criteria["page"] - 1) * criteria["per_page"]
    }

    if type.present?
      data["query"]["bool"]["must"] << {
        "type" => {
          "value" => type
        }
      }
    end

    if criteria["lower"].present?
      data["query"]["bool"]["must"] << {
        "bool" => {
          "should" => [
            {
              "constant_score" => {
                "filter" => {
                  "range" => {
                    "to_date" => {
                      "gte" => Time.mktime(criteria["lower"]).strftime("%Y-%m-%dT%H:%M:%S")
                    }
                  }
                }
              }
            },{
              "constant_score" => {
                "filter" => {
                  "missing" => {
                    "field" => "to_date"
                  }
                }
              }
            }
          ]
        }
      }
    end

    if criteria["upper"].present?
      data["query"]["bool"]["must"] << {
        "bool" => {
          "should" => [
            {
              "constant_score" => {
                "filter" => {
                  "range" => {
                    "from_date" => {
                      "lte" => Time.mktime(criteria["upper"]).strftime("%Y-%m-%dT%H:%M:%S")
                    }
                  }
                }
              }
            },{
              "constant_score" => {
                "filter" => {
                  "missing" => {
                    "field" => "from_date"
                  }
                }
              }
            }
          ]
        }
      }
    end

    if criteria["terms"].present?
      data["query"]["bool"]["must"] << {
        "query_string" => {
          "query" => criteria["terms"],
          "default_operator" => "AND",
          "analyzer" => "folding",
          "analyze_wildcard" => true,
          "fields" => [
            "title.de^20",
            "title.fr^20",
            "title.en^20",
            '_all'
          #   'uuid^20',
          #   'name^10',
          #   'distinct_name^6',
          #   'synonyms^6',
          #   'dataset.*^5',
          #   'related^4',
          #   'properties.value^3',
          #   'properties.label^2',
          #   'comment^1',
          ] 
        }
      }
    end

    if criteria["refs"].present?
      criteria['refs'].each do |ref|
        data['query']['bool']['must'] << {
          'term' => {
            'attrs.ids.6.43' => ref
          }
        }
      end
    end

    if criteria['people'].present?
      people_queries = []
      fields = [
        '12063', '12064', '12065', '12066', '12067', '12068', '12069', '12071',
        '12073', '13625', '13636', '16530'
      ]

      criteria['people'].each do |id|
        fields.each do |f|
          people_queries << {
            'term' => {
              "people.#{f}.id" => id.to_i
            }
          }
        end
      end

      data['query']['bool']['must'] << {
        'bool' => {
          'should' => people_queries,
          'minimum_should_match' => 1
        }
      }
    end

    if criteria['journals'].present?
      journals_queries = []

      criteria['journals'].uniq.each do |name|
        journals_queries << {
          'term' => {
            "journal" => name
          }
        }
      end

      data['query']['bool']['must'] << {
        'bool' => {
          'should' => journals_queries,
          'minimum_should_match' => 1
        }
      }
    end

    if type == "chronology"
      # data['query']['bool']['must'] << {
      #   'exists' => {
      #     'field' => 'from_date'
      #   }
      # }

      if criteria["category_id"].present?
        data["query"]["bool"]["must"] << {
          "constant_score" => {
            "filter" => {
              "terms" => {
                "attrs.ids.4.2" => [criteria["category_id"]],
                "execution" => "and"
              }
            }
          }
        }
      end
    end

    Rails.logger.debug data.inspect

    response = elastic.request "post", "_search", nil, data

    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end
  end

  def lookup(type = "attribs", ids = [])
    ids ||= []
    
    docs = ids.map{|id|
      {
        '_index' => config['index'],
        '_type' => type,
        '_id' => "#{id}"
      }
    }

    if ids.empty?
      [[],[],[]]
    else
      elastic.request "post", "_mget", nil, {'docs' => docs}
    end
  end

end