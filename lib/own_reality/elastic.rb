class OwnReality::Elastic

  def config
    OwnReality.config["elasticsearch"]
  end

  def drop_index
    if index_exists?
      request 'delete', '/'
    end
  end

  def create_index
    unless index_exists?
      request 'put', '/', nil, {
        "settings" => {
          "analysis" => {
            "analyzer" => {
              "folding" => {
                "tokenizer" => "standard",
                "filter" => ["lowercase", "asciifolding"]
              }
            }
          }
        }
      }
    end
  end

  def index_exists?
    response = raw_request 'head', '/'
    response.status != 404
  end

  def reset_index
    drop_index
    create_index
  end

  def flush
    request "post", "/_flush"
  end

  def refresh
    request "post", "/_refresh"
  end

  def client
    @client ||= HTTPClient.new
  end

  def request(method, path, query = {}, body = nil, headers = {})
    response = raw_request(method, path, query, body, headers)
    Rails.logger.info "ELASTIC RESPONSE: #{response.inspect}"

    if response.status >= 200 && response.status <= 299
      [response.status, response.headers, JSON.load(response.body)]
    else
      raise Exception.new([response.status, response.headers, JSON.load(response.body)])
    end
  end

  def raw_request(method, path, query = {}, body = nil, headers = {})
    Rails.logger.info "ELASTIC REQUEST: #{method} #{path}\n#{body.inspect}"

    headers.reverse_merge 'content-type' => 'application/json', 'accept' => 'application/json'
    url = "http://#{config['host']}:#{config['port']}/#{config['index']}#{path}"
    client.request(method, url, query, (body ? JSON.dump(body) : nil), headers)      
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