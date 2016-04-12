class OwnReality::ProwebReader

  def initialize
    @sources = Proweb::Project.find(16).objects
    @chronos = Proweb::Project.find(31).objects
    @archives = Proweb::Project.find(36).objects
    @articles = Proweb::Project.find(39).objects
    @interviews = Proweb::Project.find(40).objects
    @magazines = Proweb::Project.find(41).objects
    @attribute_ids = {}
    @categories = OwnReality::AttributeCategoriesReader.from_file
  end

  attr_reader :categories

  def require_attributes(a)
    if a.is_a?(Proweb::Attribute)
      @attribute_ids[a.id] = true
    else
      @attribute_ids[a] = true
    end
  end

  def each_interview(&block)
    bar = OwnReality.progress_bar :title => "caching interviews", :total => @interviews.count

    @interviews.find_each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "url" => with_translations(o, :content),
        "people" => people_by_role(o),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on)
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale

      add_lodel_html(data, o)

      yield data
      bar.increment
    end
  end

  def each_article(&block)
    bar = OwnReality.progress_bar :title => "caching articles", :total => @articles.count

    @articles.find_each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "url" => with_translations(o, :content),
        "people" => people_by_role(o),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on)
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale

      add_lodel_html(data, o)

      yield data
      bar.increment
    end
  end

  def each_magazine(&block)
    bar = OwnReality.progress_bar :title => "caching magazines", :total => @magazines.count

    @magazines.find_each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "url" => with_translations(o, :content),
        "people" => people_by_role(o),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on)
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale

      add_lodel_html(data, o)

      yield data
      bar.increment
    end
  end

  def each_chrono(&block)
    bar = OwnReality.progress_bar :title => "caching chronology", :total => @chronos.count

    @chronos.each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "people" => people_by_role(o),
        "from_date" => from_date_from(o),
        "to_date" => to_date_from(o),
        "date_imprecision" => o.date_imprecision,
        "content" => with_translations(o, :content),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on)
      }

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]

      pfc = OwnReality::ProwebFileConverter.new(o['id'])
      data["file_base_hash"] = pfc.merge_files

      unless o.category
        OwnReality.log_anomaly(
          "reading from proweb chronology data",
          "proweb-object",
          o.id,
          "doesn't have a category"
        )
      end

      yield data
      bar.increment
    end
  end

  def each_source(&block)
    bar = OwnReality.progress_bar :title => "caching sources", :total => @sources.count

    @sources.each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "journal" => fold_translations(o.journal),
        "volume" => fold_translations(o.volume),
        "people" => people_by_role(o),
        "from_date" => from_date_from(o),
        "to_date" => to_date_from(o),
        "content" => with_translations(o, :content),
        "abstract" => with_translations(o, :abstract),
        "interpretation" => with_translations(o, :interpretation),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on)
      }

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]

      pfc = OwnReality::ProwebFileConverter.new(o['id'])
      data["file_base_hash"] = pfc.merge_files

      yield data
      bar.increment
    end
  end

  def each_attrib(&block)
    bar = OwnReality.progress_bar :title => "caching attributes", :total => @attribute_ids.keys.size

    Proweb::Attribute.find(@attribute_ids.keys).each do |attrib|
      data = {
        "id" => attrib.id,
        "name" => with_translations(attrib)
      }

      yield data
      bar.increment
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
    YAML.load OwnReality.http_client.get_content(OwnReality.config["users_file"])
  end

  def attribute_proweb_categories
    result = {}
    Proweb::AttributeKlass.all.each do |klass|
      result[klass.id] = {
        "name" => klass.name,
        "kinds" => {}
      }
      klass.kinds.each do |kind|
        result[klass.id]["kinds"][kind.id] = with_translations(kind)
      end
    end
    result
  end


  protected

    def add_lodel_html(data, object)
      data["url"].each do |lang, url|
        html = OwnReality::LodelParser.new(url).parse
        if html
          data["html"] ||= {}
          data["html"][lang] = html
        else
          OwnReality.log_anomaly(
            "fetching HTML from lodel",
            "proweb-object",
            object.id,
            "html for lang #{lang} from #{url} couldn't be fetched"
          )
        end
      end
    end

    def attrs(object)
      result = {
        "ids" => {},
        "search" => {},
        "by_category" => {}
      }
      
      object.pw_attributes.each do |a|
        klass_id = a.kind.attribute_klass_id
        kind_id = a.kind.id
        result["ids"][klass_id] ||= {}
        result["ids"][klass_id][kind_id] ||= []
        result["ids"][klass_id][kind_id] << a.id
        result["search"][klass_id] ||= {}
        result["search"][klass_id][kind_id] ||= []
        result["search"][klass_id][kind_id] += with_translations(a).values

        # Schlagwort -> Deskriptor
        if klass_id == 6 && kind_id == 43
          key = categories.by_id(a.id)
          if key.present?
            result["by_category"][key] ||= []
            result["by_category"][key] << a.id
          end
        end

        require_attributes(a)
      end

      if object.category
        result["ids"][4] ||= {}
        result["ids"][4][2] ||= []
        result["ids"][4][2] << object.category_id
        result["search"][4] ||= {}
        result["search"][4][2] ||= []
        result["search"][4][2] += with_translations(object.category).values
        require_attributes(object.category)
      end

      result
    end

    def from_date_from(article)
      date_from(article.from_date) || if article.issued_on.present?
        from_issued_on(article)     
      else
        OwnReality.log_anomaly(
          "caching",
          "proweb-object",
          article.id,
          "no valid dates found"
        )
        nil
      end
    end

    def to_date_from(article)
      date_from(article.to_date) || date_from(article.from_date) || if article.issued_on.present?
        from_issued_on(article, false)
      else
        OwnReality.log_anomaly(
          "caching",
          "proweb-object",
          article.id,
          "no valid dates found"
        )
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
      OwnReality.log_anomaly(
        "caching",
        "proweb-object",
        article.id,
        "article #{article.id} produced an argument error parsing issued_on"
      )
      nil
    end

    def date_from(value)
      if value.present? 
        Time.parse(value).strftime("%Y-%m-%dT%H:%M:%S")
      end
    end

    def short_title(values)
      values.each do |k, v|
        if v.is_a?(String)
          values[k] = v.gsub(/ \(\d+\)$/, '')
        end
      end
    end

    def with_translations(o, column = :name, options = {})
      options.reverse_merge! :fill_with_nil => false

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

    def chronology_categories
      results = {}
      Proweb::Attribute.where(:attribute_kind_id => 2).find(@attribute_ids.keys).each do |c|
        results[c.id] = with_translations(c)
      end
      results
    end

end