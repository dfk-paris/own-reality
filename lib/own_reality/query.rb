class OwnReality::Query

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

  def papers(type, criteria = {})
    unless ["magazines", "articles", "interviews"].include?(type)
      raise "unknown type #{type.inspect}"
    end

    data = {}

    Rails.logger.debug data.inspect

    response = elastic.request "post", "#{type}/_search", nil, data

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

    data = {
      "aggs" => aggs,
      "query" => {
        "bool" => {
          "must" => []
        }
      },
      "size" => criteria["per_page"],
      "from" => (criteria["page"] - 1) * criteria["per_page"]
    }

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
          "analyze_wildcard" => true
          # "fields" => [
          #   'uuid^20',
          #   'name^10',
          #   'distinct_name^6',
          #   'synonyms^6',
          #   'dataset.*^5',
          #   'related^4',
          #   'properties.value^3',
          #   'properties.label^2',
          #   'comment^1',
          #   '_all'
          # 
        }
      }
    end

    if criteria["refs"].present?
      data["query"]["bool"]["must"] << {
        "constant_score" => {
          "filter" => {
            "terms" => {
              "attrs.ids.6.43" => criteria["refs"],
              "execution" => "and"
            }
          }
        }
      }
    end

    if type == "chronology"
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

    response = elastic.request "post", "#{type}/_search", nil, data

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