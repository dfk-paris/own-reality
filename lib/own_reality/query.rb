class OwnReality::Query

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def config
    @config ||= elastic.request("get", "/config/complete").last['_source']
  end

  def search(criteria = {})
    # criteria.delete "lower"
    # criteria.delete "upper"

    aggs = {
      # "journals" => {
      #   "terms" => {
      #     "field" => "journals.de"
      #   }
      # },
      # "authors" => {
      #   "terms" => {
      #     "field" => "authors"
      #   }
      # }
    }
    config["categories"]["folded_list"].each do |fc|
      aggs[fc] = {
        "terms" => {
          # "script" => "doc['refs']['#{c}'].values",
          "field" => "refs.#{fc}",
          # "lang" => "groovy",
          "exclude" => criteria["refs"],
          "size" => 5
        }
      }
    end

    data = {
      "aggs" => aggs,
      "query" => {
        "bool" => {
          "must" => []
        }
      }
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
        "constant_score" =>{
          "filter" => {
            "terms" => {
              "id_refs" => criteria["refs"],
              "execution" => "and"
            }
          }
        }
      }
    end

    Rails.logger.debug data.inspect

    response = elastic.request "post", "/articles/_search", nil, data

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
      elastic.request "post", "/_mget", nil, {'docs' => docs}
    end
  end

  def find(id)
    elastic.request "get", "/articles/#{id}"
  end

end