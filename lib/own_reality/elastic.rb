class OwnReality::Elastic

  def config
    OwnReality.config["elasticsearch"]
  end

  def indices
    return [
      "sources", "magazines", "interviews", "articles", "chronology", 'attribs',
      'people', 'config'
    ]
  end

  def drop_indices
    indices.each do |i|
      if index_exists?(i)
        request 'delete', i
      end
    end
  end

  def create_indices
    indices.each do |i|
      unless index_exists?(i)
        request 'put', i, nil, {
          "settings" => {
            "number_of_shards" => 1,
            'max_result_window' => 50000,
            "analysis" => {
              "analyzer" => {
                "folding" => {
                  "tokenizer" => "standard",
                  "filter" => ["lowercase", "asciifolding"]
                },
                'case_insensitive_sort' => {
                  'tokenizer' => 'keyword',
                  'filter' => ['lowercase']
                }
              }
            }
          }
        }
      end
    end
  end

  def index_exists?(index)
    response = raw_request 'head', index
    response.status != 404
  end

  def reset_indices
    drop_indices
    create_indices
  end

  def flush
    request "post", "_flush"
  end

  def refresh
    request "post", "_refresh"
  end

  def client
    @client ||= HTTPClient.new
  end

  def bulk(data)
    request "post", "/_bulk", nil, data
  end

  def request(method, path = nil, query = {}, body = nil, headers = {})
    response = raw_request(method, path, query, body, headers)

    if response.status >= 200 && response.status <= 299
      [response.status, response.headers, JSON.load(response.body)]
    else
      # binding.pry
      raise Exception.new([response.status, response.headers, JSON.load(response.body)])
    end
  end

  def raw_request(method, path = nil, query = {}, body = nil, headers = {})
    raise 'path cannot be nil' if path.nil?

    # fix _mget requests to include index prefix
    if path.match?((/^\/_mget/))
      body['docs'].map! do |e|
        unless e['_index'].match?(/^[^-]+\-/)
          e['_index'] = "#{config['prefix']}-#{e['_index']}"
        end
        e
      end
    end

    query ||= {}
    if config['token']
      query["token"] = config['token']
    end
    headers.reverse_merge! 'content-type' => 'application/json', 'accept' => 'application/json'
    url = if path.match?(/^\//)
      "#{config['url']}#{path}"
    else
      "#{config['url']}/#{config['prefix']}-#{path}"
    end

    if body && !body.is_a?(String)
      body = JSON.dump(body)      
    end

    client.request(method, url, query, body, headers)
  end

  def tokenize(query_string)
    query_string = "" if query_string.blank?
    query_string = query_string.join(' ') if query_string.is_a?(Array)

    query_string.scan(/\"[^\"]*\"|[^\"\s]+/).select do |term|
      term.size >= 3
    end
  end

  def escape(terms)
    terms.map do |term|
      term.gsub /[\-]/ do |m|
        '\\' + m
      end
      # + - && || ! ( ) { } [ ] ^ ~ * ? : \ /
    end
  end

  def wildcardize(tokens)
    tokens.map do |term|
      "*#{term}*"
    end
  end

  def to_array(value)
    value.is_a?(Array) ? value : [value]
  end

  def prefix_indices(names)
    names.map do |n|
      # sometimes we get index names from search results where they are already
      # prefixed
      n.match(/^#{config['prefix']}/) ?
        n :
        "#{config['prefix']}-#{n}"
    end
  end

  def self.fetch(*args)
    if @cache.is_a?(Hash)
      key = args.map(&:to_s).join('.')
      @cache[key] ||= yield
    else
      yield
    end
  end

  def handle(response)
    if response.first == 200
      # JSON.pretty_generate(response)
      response
    else
      p response
      response
    end
  end

end