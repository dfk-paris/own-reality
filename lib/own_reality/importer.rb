Bundler.require :import

class OwnReality::Importer

  def elastic
    @elastic ||= OwnReality::Elastic.new
  end

  def run
    elastic.reset_index

    reader = OwnReality::ProwebReader.new

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

    # Proweb::Project.where(:id => project_ids).all.each do |project|
    #   project.objects.each do |object|
    #     index(object)
    #   end
    # end

    # attribs = Proweb::Project.where(:id => project_ids).map do |project|
    #   project.pw_attributes.where(:attribute_kind_id => 43).all
    # end.flatten.uniq

    # attribs.each do |attrib|
    #   data = {
    #     "name" => with_translations(attrib)
    #   }

    #   request 'put', "/attribs/#{attrib.id}", nil, data  
    # end
  end

  def mapping!(folded_categories = [])
    # request "put", "/entities/_mapping", nil, {
    #   "entities" => {
    #     "properties" => {
    #       "name" => {"type" => "string", "analyzer" => "folding"},
    #       "distinct_name" => {"type" => "string", "analyzer" => "folding"},
    #       "synonyms" => {"type" => "string", "analyzer" => "folding"},
    #       "comment" => {"type" => "string", "analyzer" => "folding"},
    #       "dataset" => {
    #         "type" => "object",
    #         "properties" => {
    #           "_default_" => {"type" => "string", "analyzer" => "folding"}
    #         }
    #       },
    #       "properties" => {
    #         "type" => "object", 
    #         "properties" => {
    #           "label" => {"type" => "string", "analyzer" => "folding"},
    #           "value" => {"type" => "string", "analyzer" => "folding"}
    #         }
    #       },
    #       "id" => {"type" => "string", "index" => "not_analyzed"},
    #       "uuid" => {"type" => "string", "index" => "not_analyzed"},
    #       "tags" => {"type" => "string", "analyzer" => "keyword"},
    #       "related" => {"type" => "string", "analyzer" => "folding"},

    #       "sort" => {"type" => "string", "index" => "not_analyzed"}
    #     }
    #   }
    # }

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
              "name" => {"type" => "string", "analyzer" => "folding"}
            }
          },
          "journal" => {
            "type" => "object",
            "properties" => {
              "name" => {"type" => "string", "analyzer" => "folding"}
            }
          },
          "authors" => {"type" => "string", "analyzer" => "folding"},
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