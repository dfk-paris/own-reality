class OwnReality::Elastic

  def config
    OwnReality.config["elasticsearch"]
  end

  def drop_index
    if index_exists?
      request 'delete'
    end
  end

  def create_index
    unless index_exists?
      request 'put', nil, nil, {
        "settings" => {
          "number_of_shards" => 1,
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

  def index_exists?
    response = raw_request 'head'
    response.status != 404
  end

  def reset_index
    drop_index
    create_index
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
    query ||= {}
    query["token"] = config['token']
    headers.reverse_merge 'content-type' => 'application/json', 'accept' => 'application/json'
    url = if path.nil?
      "#{config['url']}/#{config['index']}#{path}"
    else
      if path.match(/^\//)
        "#{config['url']}#{path}"
      else
        "#{config['url']}/#{config['index']}/#{path}"
      end
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

  def self.fetch(*args)
    if @cache.is_a?(Hash)
      key = args.map(&:to_s).join('.')
      @cache[key] ||= yield
    else
      yield
    end
  end

end