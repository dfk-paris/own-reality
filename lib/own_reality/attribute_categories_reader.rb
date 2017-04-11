require "spreadsheet"

class OwnReality::AttributeCategoriesReader

  def self.from_old_data(old_data)
    categories = []
    lookup_data = {}

    old_data.records.each do |r|
      next if r['category_1'] == 'Not to be shown'

      c = r["category_1"]
      attribute_id = r["attribute_id"]

      if c.present? && (c = c.strip).present?
        if index = categories.index(c)
          lookup_data[attribute_id] = index
        else
          categories << c
          lookup_data[attribute_id] = categories.size - 1
        end
      end
    end

    path = "#{Proweb.config['files']['supplements']}/attribute_category_translations.json"
    translations = JSON.load(File.read path)
    categories.map! do |c|
      result = {
        'en' => c,
        'de' => translations[c]['de'],
        'fr' => translations[c]['fr']
      }
    end

    new(lookup_data, categories)
  end

  def initialize(data = {}, list = [])
    @data = data
    @list = list
  end

  def by_id(id)
    @data[id]
  end

  def list
    @list
  end

  def for_config
    list
  end

end