Bundler.require :import

class OwnReality::Importer

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def reader
    @reader ||= OwnReality::ProwebReader.new
  end

  def run
    elastic.reset_index

    mapping! reader.categories.folded_list

    reader.each_article do |article|
      elastic.request 'put', "/articles/#{article['id']}", nil, article
    end

    reader.each_attrib do |attrib|
      elastic.request 'put', "/attribs/#{attrib['id']}", nil, attrib
    end

    elastic.request 'put', "/config/complete", nil, {
      "categories" => {
        "list" => reader.categories.list,
        "folded_list" => reader.categories.folded_list,
      }
    }
  end

  def mapping!(folded_categories = [])
    categories_mapping = {}
    folded_categories.each do |fc|
      categories_mapping[fc] = {"type" => "integer"}
    end

    elastic.request "put", "/articles/_mapping", nil, {
      "articles" => {
        "properties" => {
          "title" => {
            "type" => "object",
            "properties" => {
              "de" => {"type" => "string", "analyzer" => "folding"},
              "fr" => {"type" => "string", "analyzer" => "folding"},
              "en" => {"type" => "string", "analyzer" => "folding"}
            }
          },
          "journal" => {
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
          "authors" => {"type" => "string", "analyzer" => "folding"},
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