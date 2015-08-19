class OwnReality::ProwebReader

  def initialize
    @sources = Proweb::Project.find(16).objects
    @chronos = Proweb::Project.find(31).objects
    @archives = Proweb::Project.find(36).objects
    @articles = Proweb::Project.find(39).objects
    @interviews = Proweb::Project.find(40).objects
    @magazines = Proweb::Project.find(41).objects
    @attributes = Proweb::Attribute.joins(:objects).
      where("objects.project_id IN (?)", Proweb.config['project_ids']).
      where("attributes.attribute_kind_id = 43")
    @categories = Proweb::Categories.from_file
  end

  attr_reader :categories

  def each_interview(&block)
    puts "caching interviews"

    @interviews.find_each do |i|
      data = {
        "id" => i.id,
        "title" => with_translations(i, :title),
        "url" => with_translations(i, :content, :fill_with_nil => false),
        "people" => people_by_role(i, :except_roles => [16530]),
        "authors" => people_by_role(i, :only_roles => [16530]),
        "refs" => {},
        "search_refs" => [],
        "id_refs" => []
      }

      merge_refs(data, i)

      pfc = OwnReality::ProwebFileConverter.new(i.id)
      data["file_base_hash"] = pfc.run

      add_lodel_html(data, i)

      yield data
    end
  end

  def each_article(&block)
    puts "caching articles"

    @articles.find_each do |a|
      data = {
        "id" => a.id,
        "title" => with_translations(a, :title),
        "url" => with_translations(a, :content, :fill_with_nil => false),
        "people" => people_by_role(a, :except_roles => [16530]),
        "authors" => people_by_role(a, :only_roles => [16530]),
        "refs" => {},
        "search_refs" => [],
        "id_refs" => []
      }

      merge_refs(data, a)

      pfc = OwnReality::ProwebFileConverter.new(a.id)
      data["file_base_hash"] = pfc.run

      add_lodel_html(data, a)

      yield data
    end
  end

  def each_magazine(&block)
    puts "caching magazines"

    @articles.find_each do |m|
      data = {
        "id" => m.id,
        "title" => with_translations(m, :title),
        "url" => with_translations(m, :content, :fill_with_nil => false),
        "people" => people_by_role(m, :except_roles => [16530]),
        "authors" => people_by_role(m, :only_roles => [16530]),
        "refs" => {},
        "search_refs" => [],
        "id_refs" => []
      }

      merge_refs(data, m)

      pfc = OwnReality::ProwebFileConverter.new(m.id)
      data["file_base_hash"] = pfc.run

      add_lodel_html(data, m)

      yield data
    end
  end

  def each_chrono(&block)
    puts "caching chronology"
    counter = 0

    @chronos.find_each do |s|
      counter += 1
      puts "#{counter}/#{@chronos.count}" if counter % 10 == 0

      data = {
        "id" => s.id,
        "title" => with_translations(s, :title),
        "short_title" => with_translations(s, :short_title),
        "journal" => fold_translations(s.journal),
        "volume" => fold_translations(s.volume),
        "people" => people_by_role(s),
        "from_date" => from_date_from(s),
        "to_date" => to_date_from(s),
        "content" => with_translations(s, :content),
        "abstract" => with_translations(s, :abstract),
        "interpretation" => with_translations(s, :interpretation)
      }

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]

      merge_refs(data, s)

      pfc = OwnReality::ProwebFileConverter.new(s['id'])
      data["file_base_hash"] = pfc.run

      yield data
    end
  end

  def each_source(&block)
    puts "caching sources"
    counter = 0

    @sources.find_each do |s|
      counter += 1
      puts "#{counter}/#{@sources.count}" if counter % 10 == 0

      data = {
        "id" => s.id,
        "title" => with_translations(s, :title),
        "short_title" => with_translations(s, :short_title),
        "journal" => fold_translations(s.journal),
        "volume" => fold_translations(s.volume),
        "people" => people_by_role(s),
        "from_date" => from_date_from(s),
        "to_date" => to_date_from(s),
        "content" => with_translations(s, :content),
        "abstract" => with_translations(s, :abstract),
        "interpretation" => with_translations(s, :interpretation)
      }

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]

      merge_refs(data, s)

      pfc = OwnReality::ProwebFileConverter.new(s['id'])
      data["file_base_hash"] = pfc.run

      yield data
    end
  end

  def each_attrib(&block)
    puts "caching attributes"
    counter = 0
    
    @attributes.all.each do |attrib|
      counter += 1
      puts "#{counter}/#{@attributes.count}" if counter % 100 == 0

      data = {
        "id" => attrib.id,
        "name" => with_translations(attrib)
      }

      yield data
    end
  end

  def categories_hash
    data = {}
    categories.data
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


  protected

  def add_lodel_html(data, object)
    data["url"].each do |lang, url|
      html = OwnReality::LodelParser.new(url).parse
      if html
        data["html"] ||= {}
        data["html"][lang] = html
        puts "Retrieved HTML for object #{object.id}"
      else
        puts "object #{object.id} didn't produce html for lang #{lang}"
      end
    end
  end

  def merge_refs(data, object)
    data.merge!(
      "refs" => {},
      "search_refs" => [],
      "id_refs" => []
    )

    object.pw_attributes.each do |a|
      cat = (categories.by_id(a.id) || "")["category"]
      cat = categories.fold_cat(cat)
      data["refs"][cat] ||= []
      data["refs"][cat] << a.id
      data["search_refs"] += with_translations(a).values
      data["id_refs"] << a.id
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

  def with_translations(o, column = :name, options = {})
    options.reverse_merge! :fill_with_nil => true

    result = if options[:fill_with_nil]
      {"en" => nil, "de" => nil, "fr" => nil}
    else
      {}
    end

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

  def people_by_role(article, options = {})
    options.reverse_merge! :only_roles => [], :except_roles => []

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

    options[:except_roles].each do |id|
      result.delete id
    end

    unless options[:only_roles].empty?
      new_result = []
      options[:only_roles].each do |role|
        new_result += result[role]
      end
      result = new_result
    end

    result
  end

end