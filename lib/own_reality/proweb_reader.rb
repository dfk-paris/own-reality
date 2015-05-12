class OwnReality::ProwebReader

  def initialize
    @articles = Proweb::Project.find(16).objects
    @chronologies = Proweb::Project.find(31).objects
    @attributes = Proweb::Attribute.
      joins(:objects => :project).
      where("projects.id IN (16, 31)").
      where("attributes.attribute_kind_id = 43")
    @categories = Proweb::Categories.from_file
  end

  attr_reader :articles
  attr_reader :chronologies
  attr_reader :attributes
  attr_reader :categories

  def categories_hash
    data = {}
    categories.
    data
  end

  def each_article(&block)
    articles.find_each do |article|
      data = {
        "id" => article.id,
        "title" => with_translations(article, :title),
        "journal" => with_translations(article.journal),
        "volume" => with_translations(article.volume),
        "authors" => article.people.map{|person| person.display_name},
        "from_date" => date_from(article.from_date),
        "to_date" => date_from(article.to_date),
        "content" => with_translations(article, :content),
        "abstract" => with_translations(article, :abstract),
        "interpretation" => with_translations(article, :interpretation),
        "refs" => {},
        "search_refs" => [],
        "id_refs" => []
      }

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]

      article.pw_attributes.each do |a|
        cat = (categories.by_id(a.id) || "")["category"]
        cat = categories.fold_cat(cat)
        data["refs"][cat] ||= []
        data["refs"][cat] << a.id
        data["search_refs"] += with_translations(a).values
        data["id_refs"] << a.id
      end

      yield data
    end
  end

  def date_from(value)
    if value.present? 
      Time.parse(value).strftime("%Y-%m-%dT%H:%M:%S")
    end
  end

  def each_attrib(&block)
    attributes.find_each do |attrib|
      data = {
        "id" => attrib.id,
        "name" => with_translations(attrib)
      }

      yield data
    end
  end

  def with_translations(o, column = :name)
    result = {"en" => nil, "de" => nil, "fr" => nil}

    if o.present?
      o.translations.each do |t|
        case t.language.name
          when "Deutsch" then result['de'] = t.send(column)
          when "Französisch" then result['fr'] = t.send(column)
          when "Englisch" then result['en'] = t.send(column)
        end
      end
    end

    result
  end

end