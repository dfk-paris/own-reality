class OwnReality::Query

  def get(type, id)
    response = elastic.request "get", "#{type}/#{id}"
    elastic.handle response
  end

  def mget(type, ids)
    ids = [ids] unless ids.is_a?(Array)
    data = {
        'docs' => ids.map{|i|
          {'_index' => type, '_id' => i}
        }
    }
    response = elastic.request 'get', "/_mget", {}, data
  end

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def config
    @config ||= elastic.request("get", "config/_doc/complete").last['_source']
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
            'last_name^10',
            'first_name^10'
          ]
        }
      }
    }

    Rails.logger.debug data.inspect

    response = elastic.request "post", "people/_search", nil, data
    elastic.handle(response)
  end

  def search(type, criteria = {})
    criteria ||= {}
    criteria["page"] = (criteria["page"] || 1).to_i
    criteria["per_page"] = (criteria["per_page"] || 10).to_i
    criteria['locale'] ||= 'de'

    search_type = criteria['search_type'] || 'query_then_fetch'
    conditions = []

    indices = ["sources", "magazines", "interviews", "articles", "chronology"]

    aggs = {}

    # binding.pry

    if criteria['register']
      if type == 'people'
        aggs['register'] = {
          'terms' => {
            'field' => 'initial.raw',
            'size' => 1000
          }
        }
      else
        aggs['register'] = {
          'terms' => {
            'field' => "initials.#{criteria['locale']}.raw",
            'size' => 1000
          }
        }
      end
    end

      if criteria['year_ranges']
        aggs['year_ranges'] = {
          "date_range" => {
            "field" => "from_date",
            "format" => "YYYY-MM-dd",
            "ranges" => (1960..1989).map{|i|
              {"from" => "#{i}-01-01", "to" => "#{i}-12-31"}
            }
          }
        }

        if ![true, 'true'].include?(criteria['year_ranges'])
          conditions << {
            "range" => {
              "from_date" => {
                "lte" => Time.mktime(criteria["year_ranges"], 12, 31).strftime("%Y-%m-%d"),
                "gte" => Time.mktime(criteria["year_ranges"], 1, 1).strftime("%Y-%m-%d")
              }
            }
          }
        end
      end

    config["categories"].each_with_index do |data, id|
      aggs["attribs.#{id}"] = {
        "terms" => {
          "field" => "attrs.by_category.#{id}",
          "size" => 21
        }
      }

      if criteria["refs"]
        aggs["attribs.#{id}"]["terms"]["exclude"] = criteria["refs"]
      end
    end

    config['roles'].each do |id, names|
      aggs["people.#{id}"] = {
        'terms' => {
          'field' => "people.#{id}.id",
          'size' => 21
        }
      }

      if criteria["people"] && criteria['people'][id.to_s]
        aggs["people.#{id}"]["terms"]["exclude"] = criteria["people"][id.to_s]
      end
    end

    aggs['journals'] = {
      'terms' => {
        'field' => 'journal_short',
        'size' => 1000
      }
    }

    if criteria['journals']
      aggs['journals']['terms']['exclude'] = criteria['journals']
    end

    unless type.present?
      aggs['type'] = {
        'terms' => {
          'field' => '_index',
          'size' => 100
        }
      }
    end

    data = {
      "aggs" => aggs,
      "query" => {
        "bool" => {
          "must" => conditions
        }
      },
      "size" => (search_type == 'count' ? 0 : criteria["per_page"]),
      "from" => (criteria["page"] - 1) * criteria["per_page"],
      "sort" => criteria['sort'] || {"date_from" => {'order' => 'asc', 'unmapped_type' => 'date'}}
    }

    # # binding.pry

    if type.present?
      indices = [type]
      # data["query"]["bool"]["must"] << {
      #   "index" => {
      #     "value" => type
      #   }
      # }
    end

    if criteria['exclude'].present?
      data['query']['bool']['must_not'] ||= []
      data['query']['bool']['must_not'] << {
        'terms' => {'ids' => criteria['exclude']}
        # 'ids' => {'values' => criteria['exclude']}
      }
    end

    if criteria["lower"].present?
      data["query"]["bool"]["must"] << {
        "bool" => {
          'minimum_should_match': 1,
          'should' => [
            {
              "range" => {
                "to_date" => {
                  "gte" => Time.mktime(criteria["lower"]).strftime("%Y-%m-%d")
                }
              }
            },{
              'bool' => {
                'must_not' => [
                  {
                    'exists' => {
                      'field' => 'to_date'
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    end

    if criteria["upper"].present?
      data["query"]["bool"]["must"] << {
        "bool" => {
          'minimum_should_match': 1,
          'should' => [
            {
              "range" => {
                "from_date" => {
                  "lte" => Time.mktime(criteria["upper"]).strftime("%Y-%m-%d")
                }
              }
            },{
              'bool' => {
                'must_not' => [
                  {
                    'exists' => {
                      'field' => 'from_date'
                    }
                  }
                ]
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
            "title.*^20",
            'interpretation.*^10',

            'content',
            'abstract',
            'search_refs',

            'people.*.first_name',
            'people.*.last_name',
            'attrs.search.*.*',

            'html.*'
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
      criteria['people'].each do |role_id, people|
        people.each do |id|
          data['query']['bool']['must'] << {
            'term' => {
              "people.#{role_id}.id" => id.to_i
            }
          }
        end
      end
    end

    if criteria['journals'].present?
      criteria['journals'].each do |short|
        data['query']['bool']['must'] << {
          'term' => {
            "journal_short" => short
          }
        }
      end
    end

    if type == 'attribs'
      if criteria['kind_id']
        data['query']['bool']['must'] << {
          'term' => {
            'kind_id' => criteria['kind_id']
          }
        }
      end

      if criteria['klass_id']
        data['query']['bool']['must'] << {
          'term' => {
            'klass_id' => criteria['klass_id']
          }
        }
      end

      if criteria['category_id']
        data['query']['bool']['must'] << {
          'term' => {
            'category_id' => criteria['category_id']
          }
        }
      end
    end

    if criteria['initial']
      if type == 'people'
        data['query']['bool']['must'] << {
          'term' => {
            "initial.raw" => criteria['initial']
          }
        }
      else
        data['query']['bool']['must'] << {
          'term' => {
            "initials.#{criteria['locale']}.raw" => criteria['initial']
          }
        }
      end
    end

    indices = elastic.prefix_indices(indices)

    Rails.logger.debug "Searching in indices #{indices.inspect}"
    Rails.logger.debug JSON.pretty_generate(data)
    response = elastic.request "post", "/#{indices.join(',')}/_search", nil, data
    # binding.pry
    elastic.handle response
  end

  def lookup(index = "attribs", ids = [])
    ids ||= []
    
    docs = ids.map{|id|
      {
        '_index' => index,
        '_id' => "#{id}"
      }
    }

    if ids.empty?
      [[],[],[]]
    else
      response = elastic.request "post", "/_mget", nil, {'docs' => docs}
      elastic.handle(response)
    end
  end

end