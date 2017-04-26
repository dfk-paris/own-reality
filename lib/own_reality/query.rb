class OwnReality::Query

  def get(type, id)
    response = elastic.request "get", "#{type}/#{id}"
    elastic.handle resposne
  end

  def mget(type, ids)
    ids = [ids] unless ids.is_a?(Array)
    data = {
        'docs' => ids.map{|i|
          {'_index' => config['index'], '_type' => type, '_id' => i}
        }
    }
    response = elastic.request 'get', "_mget", {}, data
  end

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def config
    @config ||= elastic.request("get", "config/complete").last['_source']
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

    aggs = {}

    if criteria['register']
      if type == 'people'
        aggs['register'] = {
          'terms' => {
            'field' => 'initial',
            'size' => 0
          }
        }
      else
        aggs['register'] = {
          'terms' => {
            'field' => "initials.#{criteria['locale']}",
            'size' => 0
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
              "lte" => Time.mktime(criteria["year_ranges"], 12, 31).strftime("%Y-%m-%dT%H:%M:%S"),
              "gte" => Time.mktime(criteria["year_ranges"], 1, 1).strftime("%Y-%m-%dT%H:%M:%S")
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
        'size' => 0
      }
    }

    if criteria['journals']
      aggs['journals']['terms']['exclude'] = criteria['journals']
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
          "must" => conditions
        }
      },
      "size" => (search_type == 'count' ? 0 : criteria["per_page"]),
      "from" => (criteria["page"] - 1) * criteria["per_page"],
      "sort" => criteria['sort'] || {"date_from" => {'order' => 'asc', 'ignore_unmapped' => true}}
    }

    # binding.pry

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
                      "lte" => Time.mktime(criteria["upper"], 12, 31).strftime("%Y-%m-%dT%H:%M:%S")
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
            'interpretation.de^10',
            'interpretation.fr^10',
            'interpretation.en^10',
            '_all'
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
            "initial" => criteria['initial']
          }
        }
      else
        data['query']['bool']['must'] << {
          'term' => {
            "initials.#{criteria['locale']}" => criteria['initial']
          }
        }
      end
    end

    Rails.logger.debug data.inspect
    response = elastic.request "post", "_search", nil, data
    elastic.handle response
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
      response = elastic.request "post", "_mget", nil, {'docs' => docs}
      elastic.handle(response)
    end
  end

end