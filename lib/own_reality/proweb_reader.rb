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

  def roles
    ids = Proweb::ObjectPerson.group(:kind_id).count.keys
    results = {}
    Proweb::Attribute.where(:id => ids).each do |a|
      results[a.id] = with_translations(a)
    end
    results
  end

  def people
    YAML.load_file Proweb.config["users_file"]
  end

  def each_article(&block)
    puts "caching articles"
    counter = 0

    articles.find_each do |article|
      counter += 1
      puts "#{counter}/#{articles.count}" if counter % 10 == 0

      data = {
        "id" => article.id,
        "title" => with_translations(article, :title),
        "short_title" => with_translations(article, :short_title),
        "journal" => fold_translations(article.journal),
        "volume" => fold_translations(article.volume),
        "people" => people_by_role(article),
        "from_date" => from_date_from(article),
        "to_date" => to_date_from(article),
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

      pfc = OwnReality::ProwebFileConverter.new(article['id'])
      data["file_base_hash"] = pfc.run

      yield data
    end
  end

  def from_date_from(article)
    date_from(article.from_date) || if article.issued_on.present?
      from_issued_on(article)     
    else
      puts "article #{article.id} doesn't have valid dates"
      nil
    end
  end

  def to_date_from(article)
    date_from(article.to_date) || date_from(article.from_date) || if article.issued_on.present?
      from_issued_on(article, false)
    else
      puts "article #{article.id} doesn't have valid dates"
      nil
    end
  end

  def from_issued_on(article, from = true)
    addition = (from ? 0 : 1)
    parts = article.issued_on.split(".").map{|i| i.to_i}
    result = if article.ed_ignore_month
      Time.mktime parts[0] + addition
    elsif article.ed_ignore_day
      Time.mktime parts[0], parts[1] + addition
    else
      Time.mktime parts[0], parts[1], parts[2] + addition
    end
    (result - addition.days).strftime("%Y-%m-%dT%H:%M:%S")
  rescue ArgumentError => e
    puts "article #{article.id} produced an argument error"
    nil
  end

  def date_from(value)
    if value.present? 
      Time.parse(value).strftime("%Y-%m-%dT%H:%M:%S")
    end
  end

  def each_attrib(&block)
    puts "caching attributes"
    counter = 0

    attributes.find_each do |attrib|
      counter += 1
      puts "#{counter}/#{attributes.count}" if counter % 100 == 0

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

  def fold_translations(o, column = :name)
    if o.present?
      o.translations.each do |t|
        if t.send(column).present?
          return t.send(column)
        end
      end
    end

    nil
  end

  def people_by_role(article)
    result = {}
    article.people_by_role_ids.each do |k, v|
      result[k] = v.map do |person|
        r = {
          "first_name" => person.first_name,
          "last_name" => person.last_name,
          "id" => person.id
        }
      end
    end
    result
  end

end