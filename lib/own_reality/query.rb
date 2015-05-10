class OwnReality::Query

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def config
    @config ||= elastic.request("get", "/config/complete").last['_source']
  end

  def search(criteria = {})
    p criteria

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
          "size" => 5
        }
      }
    end

    data = {
      "aggs" => aggs
    }

    if criteria["terms"].present?
      data["query"] = {
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
          # ]
        }
      }
    end

    p data

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

end