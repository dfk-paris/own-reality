class OwnReality::ProwebReader

  def initialize
    @sources = Proweb::Project.find(16).objects
    @chronos = Proweb::Project.find(31).objects
    @articles = Proweb::Project.find(39).objects
    @interviews = Proweb::Project.find(40).objects
    @magazines = Proweb::Project.find(41).objects
    @attribute_ids = {}
    @people_ids = {}

    @old_dir = Proweb.config['files']['supplements']
  end

  def old_data
    @old_data ||= {
      'attributes' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.attributes.all_or_projects.xls", 'attribute_id'),
      'articles' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.ownreality_aufsätze.xls"),
      'chronology' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.ownreality_chronologie.xls"),
      'interviews' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.ownreality_interviews.xls"),
      'magazines' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.ownreality_zeitschriften.xls"),
      'sources' => Proweb::OldDataMerger.new("#{@old_dir}/proweb.ownreality_datenbank.xls")
    }
  end

  def config
    return [
      {
        "categories" => categories.for_config,
        "roles" => roles,
        "plural_roles" => plural_roles,
        "people" => people,
        "chronolgy_categories" => chronology_categories,
        "klasses" => attribute_proweb_categories,
        "perspectivia_link_map" => JSON.parse(File.read "#{@old_dir}/perspectivia_link_map.json")
      }
    ]
  end

  def categories
    @categories ||= OwnReality::AttributeCategoriesReader.from_old_data(
      old_data['attributes']
    )
  end

  # def translators
  #   @translators ||= OwnReality::OldDataMerger.from_file
  # end

  def require_attributes(a)
    if a.is_a?(Proweb::Attribute)
      @attribute_ids[a.id] = true
    else
      @attribute_ids[a] = true
    end
  end

  def require_people(ids, role_id)
    ids = [ids] unless ids.is_a?(Array)
    ids.each do |id|
      @people_ids[id] ||= []
      @people_ids[id] << role_id
      @people_ids[id].uniq!
    end
  end

  def each_interview(&block)
    bar = OwnReality.progress_bar :title => "caching interviews", :total => @interviews.count

    @interviews.find_each do |o|
      data = {
        "id" => o.id,
        "title" => with_translations(o, :title),
        "short_title" => short_title(with_translations(o, :short_title)),
        "people" => people_by_role(o, role_mapping: {
          12065 => 12064,
          12066 => 12064,
          12067 => 12064,
          12068 => 12064,
          12071 => 12064,
          12073 => 12064,
          13625 => 12064,
          13636 => 12064
        }),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on),
        "created_by" => o.created_by
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale

      add_html(data, o)
      add_teaser(data, o)

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
        "people" => people_by_role(o, role_mapping: {
          12065 => 12064,
          12066 => 12064,
          12067 => 12064,
          12068 => 12064,
          12071 => 12064,
          12073 => 12064,
          13625 => 12064,
          13636 => 12064
        }),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on),
        "created_by" => o.created_by
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale

      add_html(data, o)
      add_teaser(data, o)

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
        "people" => people_by_role(o, role_mapping: {
          12065 => 12064,
          12066 => 12064,
          12067 => 12064,
          12068 => 12064,
          12071 => 12064,
          12073 => 12064,
          13625 => 12064,
          13636 => 12064
        }),
        "attrs" => attrs(o),
        "updated_by" => o.updated_by,
        "updated_at" => date_from(o.updated_on),
        "created_by" => o.created_by
      }

      pfc = OwnReality::ProwebFileConverter.new(o.id)
      data["pdfs"] = pfc.pdfs_by_locale
      data['journal_short'] = (
        short_journal_name_map[data['title'].values.first] ||
        data['title'].values.first
      )
      data['cover'] = pfc.cover

      add_html(data, o)
      add_teaser(data, o)

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
        "updated_at" => date_from(o.updated_on),
        "created_by" => o.created_by
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
        'id' => o.id,
        'title' => with_translations(o, :title),
        'short_title' => short_title(with_translations(o, :short_title)),
        'journal' => fold_translations(o.journal),
        'journal_id' => journal_id(o),
        'volume' => fold_translations(o.volume),
        'people' => people_by_role(o, index_people: true),
        'from_date' => from_date_from(o),
        'to_date' => to_date_from(o),
        'content' => with_translations(o, :content),
        'abstract' => with_translations(o, :abstract),
        'interpretation' => with_translations(o, :interpretation),
        'attrs' => attrs(o),
        'updated_by' => o.updated_by,
        'updated_at' => date_from(o.updated_on),
        'created_by' => (old_data['sources'].by_id[o.id] || {})['created_by'],
        'scan_copyright' => (old_data['sources'].by_id[o.id] || {})['link'],
        'translators' => {
          'lang' => (old_data['sources'].by_id[o.id] || {})['lang'],
          'tr_desc' => (old_data['sources'].by_id[o.id] || {})['tr_desc'],
          'tr_name' => (old_data['sources'].by_id[o.id] || {})['tr_name']
        }
      }

      unless data['translators']
        # binding.pry
        OwnReality.log_anomaly(
          "matching translators data to source entries",
          "proweb-object",
          o.id,
          "doesn't have translators data"
        )
      end

      data["from_date"] ||= data["to_date"]
      data["to_date"] ||= data["from_date"]
      data['journal_short'] = short_journal_name_map[data['journal']] || data['journal']

      pfc = OwnReality::ProwebFileConverter.new(o['id'])
      data["file_base_hash"] = pfc.merge_files

      yield data
      bar.increment
    end
  end

  def each_attrib(&block)
    bar = OwnReality.progress_bar :title => "caching attributes", :total => @attribute_ids.keys.size

    Proweb::Attribute.includes(:kind).find(@attribute_ids.keys).each do |attrib|
      data = {
        'id' => attrib.id,
        'kind_id' => attrib.attribute_kind_id,
        'klass_id' => attrib.kind.attribute_klass_id,
        'category_id' => categories.position_for(
          (old_data['attributes'].by_id[attrib.id] || {})['category_1']
        ),
        'name' => with_translations(attrib),
        'initials' => {}
      }

      data['name'].each do |k, v|
        data['initials'][k] = v[0].downcase
      end

      yield data
      bar.increment
    end
  end

  def each_person(&block)
    bar = OwnReality.progress_bar :title => "caching people", :total => @people_ids.keys.size

    @people_ids.each do |person_id, role_ids|
      person = Proweb::Person.find(person_id)
      data = {
        'id' => person.id,
        'first_name' => person.first_name,
        'last_name' => person.last_name,
        'initial' => person.last_name.downcase[0],
        'role_ids' => role_ids
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
    rename_map = {
      'Ersteller' => 'Autor',
      'Créateur' => 'auteur',
      'Creator' => 'author',
      'Beteiligt' => 'Person',
      'Impliqué' => 'personne',
      'Involved' => 'person'
    }

    ids = Proweb::ObjectPerson.group(:kind_id).count.keys
    results = {}
    Proweb::Attribute.where(:id => ids).each do |a|
      results[a.id] = with_translations(a)
      results[a.id].each do |k, v|
        results[a.id][k] = rename_map[v] || results[a.id][k]
      end
    end
    results
  end

  def plural_roles
    return {
      "12063": {"de":"Autoren", "fr":"auteurs", "en":"authors"},
      "12064": {"de":"Personen", "fr":"personnes", "en":"persons"},
      "12065": {"de":"Dargestellte", "fr":"Montrés", "en":"Shown"},
      "12066": {"de":"Auftraggeber", "fr":"Clients", "en":"Clients"},
      "12068": {"de":"Bearbeiter", "fr":"Editeurs", "en":"Editors"},
      "12069": {"de":"Übersetzer", "fr":"Traducteurs", "en":"Translators"},
      "12071": {"de":"Darsteller", "fr":"Acteurs", "en":"Actors"},
      "12073": {"de":"Adressaten", "fr":"Destinataires", "en":"Addressees"},
      "13625": {"de":"ausgestellte Künstler"},
      "13636": {"de":"ausgestelle Künstler"},
      "16530": {"de":"Autoren", "fr":"Auteurs", "en":"Authors"}
    }
  end

  def people
    path = "#{Proweb.config['files']['supplements']}/users.json"
    YAML.load File.read(path)
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

    def journal_id(source)
      @journal_cache ||= begin
        result = {}
        @magazines.each do |mag|
          mag.translations.map{|t| t.title.strip}.uniq.each do |name|
            result[name] = mag.id
            if sn = short_journal_name_map[name]
              result[sn] = mag.id
            end
          end
        end
        result
      end

      if source.journal
        names = source.journal.translations.map{|t| t.name}.uniq
        mag = nil
        names.each do |name|
          mag ||= @journal_cache[name]
          mag ||= @journal_cache[short_journal_name_map[name]]
        end

        if mag
          mag
        else
          # binding.pry
          OwnReality.log_anomaly(
            "matching sources to journals",
            "proweb-object",
            source.id,
            "the journal #{names.inspect} couldn't be found in #{@journal_cache.keys.inspect}"
          )

          nil
        end
      else
        OwnReality.log_anomaly(
          "matching sources to journals",
          "proweb-object",
          source.id,
          "the source #{source.id} doesn't have a journal"
        )
        nil
      end
    end

    def add_html(data, object)
      data['html'] = OwnReality::TeiHtmlParser.new(object.id).html
    end

    def add_teaser(data, object)
      data['teaser'] = OwnReality::TeiHtmlParser.new(object.id).teaser
    end

    def attrs(object, options = {})
      result = {
        "ids" => {},
        "by_category" => {}
      }
      
      object.pw_attributes.each do |a|
        next if attr_ignore_list.include?(a.id)

        klass_id = a.kind.attribute_klass_id
        kind_id = a.kind.id
        result["ids"][klass_id] ||= {}
        result["ids"][klass_id][kind_id] ||= []
        result["ids"][klass_id][kind_id] << a.id

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
      (result - addition.days).strftime("%Y-%m-%d")
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
        Time.parse(value).strftime("%Y-%m-%d")
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
        {"en" => nil, "de" => nil, "fr" => nil, 'pl' => nil}
      else
        {}
      end

      if o.present?
        o.translations.each do |t|
          case t.language.name
            when "Deutsch" then result['de'] = t.send(column)
            when "Französisch" then result['fr'] = t.send(column)
            when "Englisch" then result['en'] = t.send(column)
            when "Neutral" then result['pl'] = t.send(column)
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
      options.reverse_merge!(
        index_people: true,
        role_mapping: {
          12065 => 12064,
          12066 => 12064,
          12067 => 12064,
          12068 => 12064,
          12071 => 12064,
          12073 => 12064,
          13625 => 12064,
          13636 => 12064,
          16530 => 12064
        },
        drop_roles: [12069]
      )

      data = {}
      article.people_by_role_ids.each do |k, v|
        unless options[:drop_roles].include?(k)
          role = options[:role_mapping][k] || k
          data[role] ||= []
          data[role] += v
        end
      end

      result = {}
      data.each do |k, v|
        result[k] = v.map do |person|
          require_people(person.id, k) if options[:index_people]
          r = {
            "first_name" => person.first_name,
            "last_name" => person.last_name,
            "id" => person.id
          }
        end
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


    # dirtiest hack ever

    def short_journal_name_map
      return {
        "Art press" => "Art press",
        "Art press international" => "Art press",
        "Bildende Kunst" => "Bildende Kunst",
        "Chroniques de l'art vivant" => "Chroniques de l'art vivant",
        "Das Kunstwerk. The Work of Art" => "Das Kunstwerk",
        "Das Kunstwerk. Zeitschrift für Moderne Kunst" => "Das Kunstwerk",
        "Fotogeschichte. Beiträge zur Geschichte und Ästhetik der Fotografie" => "Fotogeschichte",
        "Interfunktionen" => "Interfunktionen",
        "kritische berichte. Zeitschrift für Kunst- und Kulturwissenschaften" => "kritische berichte",
        "Kultura" => "Kultura",
        "KUNSTFORUM International. Die aktuelle Zeitschrift für alle Bereiche der Bildenden Kunst" => "KUNSTFORUM International",
        "L'Art vivant" => "Chroniques de l'art vivant",
        "Les Lettres Françaises" => "Les Lettres Françaises",
        "Opus International" => "Opus International",
        "Projekt" => "Projekt",
        "Przegląd Artystyczny" => "Przegląd Artystyczny",
        "Robho" => "Robho",
        "Struktury" => "Struktury",
        "Sztuka" => "Sztuka",
        "tendenzen. Zeitschrift für engagierte Kunst" => "tendenzen",
        "Weltkunst" => "Weltkunst",
        "Wolkenkratzer Art Journal" => "Wolkenkratzer Art Journal"
      }
    end

    def attr_ignore_list
      [15894, 8803, 13619, 9063, 12157]
    end

end