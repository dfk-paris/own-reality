Bundler.require :import

class OwnReality::Import

  def initialize(reader = nil)
    @elastic = OwnReality::Elastic.new
    @reader = reader || OwnReality::ProwebReader.new
  end

  attr_reader :reader, :elastic

  def run
    elastic.reset_indices
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
      elastic.request 'put', "interviews/_doc/#{i['id']}", nil, i
    end
  end

  def magazines
    reader.each_magazine do |m|
      elastic.request 'put', "magazines/_doc/#{m['id']}", nil, m
    end
  end

  def articles
    reader.each_article do |a|
      elastic.request 'put', "articles/_doc/#{a['id']}", nil, a
    end
  end

  def chronology
    reader.each_chrono do |a|
      # some values are boolean, others are 'day' or 'month' this produces
      # incompatible mapping in ES 7
      a['date_imprecision'] = '' if a['date_imprecision'] == false

      elastic.request 'put', "chronology/_doc/#{a['id']}", nil, a
    end
  end

  def sources
    reader.each_source do |s|
      elastic.request 'put', "sources/_doc/#{s['id']}", nil, s
    end
  end

  def attributes
    reader.each_attrib do |a|
      elastic.request 'put', "attribs/_doc/#{a['id']}", nil, a
    end
  end

  def config
    data = reader.config[0]
    data['prefix'] = elastic.config['prefix']
    elastic.request 'put', "config/_doc/complete", nil, data
  end

  def people
    reader.each_person do |person|
      elastic.request 'put', "people/_doc/#{person['id']}", nil, person
    end
  end

  def mapping
    ["sources", "magazines", "interviews", "articles", "chronology"].each do |t|
      elastic.request "put", "#{t}/_mapping", nil, {
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
              "mapping" => {"type" => "text", 'analyzer' => 'folding'}
            } 
          },{
            "people_last_names" => {
              "path_match" => "people.*.last_name", 
              "mapping" => {"type" => "text", 'analyzer' => 'folding'}
            } 
          },{
            "attrs_search_klass_kinds" => {
              "path_match" => "attrs.search.*.*",
              "mapping" => {"type" => "text", "analyzer" => "folding"}
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
              "de" => {"type" => "text", "analyzer" => "folding"},
              "fr" => {"type" => "text", "analyzer" => "folding"},
              "en" => {"type" => "text", "analyzer" => "folding"}
            }
          },
          "content" => {
            "type" => "object",
            "properties" => {
              "de" => {"type" => "text", "analyzer" => "folding"},
              "fr" => {"type" => "text", "analyzer" => "folding"},
              "en" => {"type" => "text", "analyzer" => "folding"}
            }
          },
          "abstract" => {
            "type" => "object",
            "properties" => {
              "de" => {"type" => "text", "analyzer" => "folding"},
              "fr" => {"type" => "text", "analyzer" => "folding"},
              "en" => {"type" => "text", "analyzer" => "folding"}
            }
          },
          "interpretation" => {
            "type" => "object",
            "properties" => {
              "de" => {"type" => "text", "analyzer" => "folding"},
              "fr" => {"type" => "text", "analyzer" => "folding"},
              "en" => {"type" => "text", "analyzer" => "folding"}
            }
          },
          "journal" => {"type" => "text", "index" => "false"},
          "journal_short" => {"type" => "keyword"},
          "journal_id" => {"type" => "long", "index" => "false"},
          "volume" => {"type" => "keyword", "index" => "false"},
          "from_date" => {"type" => "date", "format" => "YYYY-MM-dd"},
          "to_date" => {"type" => "date", "format" => "YYYY-MM-dd"},
          "search_refs" => {"type" => "text", "analyzer" => "folding"},
        }
      }
    end

    elastic.request "put", "attribs/_mapping", nil, {
      "properties" => {
        "name" => {
          "type" => "object",
          "properties" => {
            'de' => {'type' => 'text', 'analyzer' => 'case_insensitive_sort'},
            'fr' => {'type' => 'text', 'analyzer' => 'case_insensitive_sort'},
            'en' => {'type' => 'text', 'analyzer' => 'case_insensitive_sort'}
          }
        },
        'initials' => {
          'properties' => {
            'de' => {'type' => 'text', 'index' => 'false'},
            'fr' => {'type' => 'text', 'index' => 'false'},
            'en' => {'type' => 'text', 'index' => 'false'}
          }
        }
      }
    }

    elastic.request "put", "people/_mapping", nil, {
      "properties" => {
        "first_name" => {"type" => "text", 'analyzer' => 'case_insensitive_sort'},
        "last_name" => {"type" => "text", 'analyzer' => 'case_insensitive_sort'},
        'initial' => {'type' => 'text', 'index' => 'false'}
      }
    }
  end

end