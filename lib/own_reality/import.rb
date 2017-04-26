Bundler.require :import

class OwnReality::Import

  def initialize(reader = nil)
    @elastic = OwnReality::Elastic.new
    @reader = reader || OwnReality::ProwebReader.new
  end

  attr_reader :reader, :elastic

  def run
    elastic.reset_index
    mapping

    config
    articles
    interviews
    magazines
    chronology
    sources

    people
    attributes
  end

  def interviews
    reader.each_interview do |i|
      elastic.request 'put', "interviews/#{i['id']}", nil, i
    end
  end

  def magazines
    reader.each_magazine do |m|
      elastic.request 'put', "magazines/#{m['id']}", nil, m
    end
  end

  def articles
    reader.each_article do |a|
      elastic.request 'put', "articles/#{a['id']}", nil, a
    end
  end

  def chronology
    reader.each_chrono do |a|
      elastic.request 'put', "chronology/#{a['id']}", nil, a
    end
  end

  def sources
    reader.each_source do |s|
      elastic.request 'put', "sources/#{s['id']}", nil, s
    end
  end

  def attributes
    reader.each_attrib do |a|
      elastic.request 'put', "attribs/#{a['id']}", nil, a
    end
  end

  def config
    elastic.request 'put', "config/complete", nil, reader.config[0]
  end

  def people
    reader.each_person do |person|
      elastic.request 'put', "people/#{person['id']}", nil, person
    end
  end

  def mapping
    ["sources", "magazines", "interviews", "articles", "chronology"].each do |t|
      elastic.request "put", "#{t}/_mapping", nil, {
        "#{t}" => {
          "dynamic_templates" => [
            {
              "attrs_ids_klass_kinds" => {
                "path_match" => "attrs.ids.*.*", 
                "mapping" => {"type" => "integer"}
              }
            },{
              "people_ids" => {
                "path_match" => "people.*.id", 
                "mapping" => {"type" => "integer"}
              } 
            },{
              "people_first_names" => {
                "path_match" => "people.*.first_name", 
                "mapping" => {"type" => "string", 'analyzer' => 'folding'}
              } 
            },{
              "people_last_names" => {
                "path_match" => "people.*.last_name", 
                "mapping" => {"type" => "string", 'analyzer' => 'folding'}
              } 
            },{
              "attrs_search_klass_kinds" => {
                "path_match" => "attrs.search.*.*",
                "mapping" => {"type" => "string", "analyzer" => "folding"}
              }
            },{
              "attrs_by_category" => {
                "path_match" => "attrs.by_category.*", 
                "mapping" => {"type" => "integer"}
              }
            }
          ],
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
            "journal" => {"type" => "string", "index" => "not_analyzed"},
            "journal_short" => {"type" => "string", "index" => "not_analyzed"},
            "journal_id" => {"type" => "long", "index" => "not_analyzed"},
            "volume" => {"type" => "string", "index" => "not_analyzed"},
            "from_date" => {"type" => "date", "format" => "date_hour_minute_second"},
            "to_date" => {"type" => "date", "format" => "date_hour_minute_second"},
            "search_refs" => {"type" => "string", "analyzer" => "folding"},
          }
        }
      }
    end

    elastic.request "put", "attribs/_mapping", nil, {
      "attribs" => {
        "properties" => {
          "name" => {
            "type" => "object",
            "properties" => {
              'de' => {'type' => 'string', 'analyzer' => 'case_insensitive_sort'},
              'fr' => {'type' => 'string', 'analyzer' => 'case_insensitive_sort'},
              'en' => {'type' => 'string', 'analyzer' => 'case_insensitive_sort'}
            }
          },
          'initials' => {
            'properties' => {
              'de' => {'type' => 'string', 'index' => 'not_analyzed'},
              'fr' => {'type' => 'string', 'index' => 'not_analyzed'},
              'en' => {'type' => 'string', 'index' => 'not_analyzed'}
            }
          }
        }
      }
    }

    elastic.request "put", "people/_mapping", nil, {
      "people" => {
        "properties" => {
          "first_name" => {"type" => "string", 'analyzer' => 'case_insensitive_sort'},
          "last_name" => {"type" => "string", 'analyzer' => 'case_insensitive_sort'},
          'initial' => {'type' => 'string', 'index' => 'not_analyzed'}
        }
      }
    }
  end

end