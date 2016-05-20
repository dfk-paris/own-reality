class OwnReality::Export

  def initialize(target_dir = "~/Desktop/or_out")
    @target_dir = File.expand_path(target_dir)
    system "mkdir -p #{@target_dir}"
  end

  def json
    write index_settings, to: 'index'
    write types, to: 'types'
    mappings.each do |type, mapping|
      write mapping, to: "#{type}.mapping"
    end
    data.each do |type, data|
      write data, to: "#{type}.data"
    end
  end

  def index_settings
    response = elastic.request "get", "/_settings"
    elastic.handle(response)[2][index]
  end

  def mappings
    response = elastic.request "get", "/_mapping"
    elastic.handle(response)[2][index]['mappings']
  end

  def types
    mappings.keys
  end

  def data
    results = {}
    types.each do |type|
      done = false
      skip = 0
      while !done
        response = elastic.request "get", "#{type}/_search?size=1000&from=#{skip}"
        request_data = elastic.handle(response)[2]
        results[type] ||= []
        results[type] += request_data['hits']['hits'].map{|i| i['_source']}
        skip += 1000
        done = true if results[type].size == request_data['hits']['total']
      end
    end
    results
  end


  protected

    def index
      OwnReality.config['elasticsearch']['index']
    end

    def elastic
      @elastic ||= OwnReality::Elastic.new
    end

    def write(data, options)
      File.open "#{@target_dir}/#{options[:to]}.json", 'w+' do |f|
        f.write JSON.dump(data)
      end
    end

end