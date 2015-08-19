Bundler.require :import

class OwnReality::Import

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def reader
    @reader ||= OwnReality::ProwebReader.new
  end

  def run
    elastic.reset_index
    mapping

    config
    articles
    interviews
    magazines
    chronology
    sources

    attributes
  end

  def interviews
    reader.each_interview do |i|
      elastic.request 'put', "/interviews/#{i['id']}", nil, i
    end
  end

  def magazines
    reader.each_magazine do |m|
      elastic.request 'put', "/magazines/#{m['id']}", nil, m
    end
  end

  def articles
    reader.each_article do |a|
      elastic.request 'put', "/articles/#{a['id']}", nil, a
    end
  end

  def chronology
    reader.each_chrono do |c|
      elastic.request 'put', "/chronology/#{c['id']}", nil, c
    end
  end

  def sources
    reader.each_source do |s|
      elastic.request 'put', "/sources/#{s['id']}", nil, s
    end
  end

  def attributes
    reader.each_attrib do |a|
      elastic.request 'put', "/attribs/#{a['id']}", nil, a
    end
  end

  def config
    elastic.request 'put', "/config/complete", nil, {
      "categories" => {
        "list" => reader.categories.list,
        "folded_list" => reader.categories.folded_list,
      },
      "roles" => reader.roles,
      "people" => reader.people
    }
  end

  def mapping
    folded_categories = reader.categories.folded_list

    categories_mapping = {}
    folded_categories.each do |fc|
      categories_mapping[fc] = {"type" => "integer"}
    end

    ["sources", "magazines", "interviews", "articles", "chronology"].each do |t|
      elastic.request "put", "/#{t}/_mapping", nil, {
        "#{t}" => {
          "properties" => {
            "title" => {
              "type" => "object",
              "properties" => {
                "de" => {"type" => "string", "analyzer" => "folding"},
                "fr" => {"type" => "string", "analyzer" => "folding"},
                "en" => {"type" => "string", "analyzer" => "folding"}
              }
            },
            "content" => {
              "type" => "object",
              "properties" => {
                "de" => {"type" => "string", "analyzer" => "folding"},
                "fr" => {"type" => "string", "analyzer" => "folding"},
                "en" => {"type" => "string", "analyzer" => "folding"}
              }
            },
            "abstract" => {
              "type" => "object",
              "properties" => {
                "de" => {"type" => "string", "analyzer" => "folding"},
                "fr" => {"type" => "string", "analyzer" => "folding"},
                "en" => {"type" => "string", "analyzer" => "folding"}
              }
            },
            "interpretation" => {
              "type" => "object",
              "properties" => {
                "de" => {"type" => "string", "analyzer" => "folding"},
                "fr" => {"type" => "string", "analyzer" => "folding"},
                "en" => {"type" => "string", "analyzer" => "folding"}
              }
            },
            "journal" => {"type" => "string", "analyzer" => "folding"},
            "volume" => {"type" => "string", "index" => "not_analyzed"},
            "from_date" => {"type" => "date", "format" => "date_hour_minute_second"},
            "to_date" => {"type" => "date", "format" => "date_hour_minute_second"},
            "search_refs" => {"type" => "string", "analyzer" => "folding"},
            "id_refs" => {"type" => "integer"},
            "refs" => {
              "type" => "object",
              "properties" => categories_mapping
            }
          }
        }
      }
    end

    elastic.request "put", "/attribs/_mapping", nil, {
      "attribs" => {
        "properties" => {
          "name" => {
            "type" => "object",
            "properties" => {
              "name" => {"type" => "string", "analyzer" => "folding"}
            }
          }
        }
      }
    }
  end

end