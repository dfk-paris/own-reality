require "spreadsheet"

class OwnReality::AttributeCategoriesReader

  def self.from_file
    data = OwnReality.http_client.get_content(OwnReality.config["attribute_categories_file"])
    book = ::Spreadsheet.open(StringIO.new(data))

    records = []
    book.worksheets.each do |sheet|
      sheet.each 1 do |row|
        headers = sheet.first.to_a
        record = {}
        headers.each_with_index do |h, i|
          value = row[i]
          value = value.value if value.respond_to?(:value)
          record[h] = value
        end
        records << record if record['attribute_id'].present?
      end
    end

    categories = []
    lookup_data = {}

    records.each do |r|
      c = r["category_1"].strip
      attribute_id = r["attribute_id"]

      if c.present?
        if index = categories.index(c)
          lookup_data[attribute_id] = index
        else
          categories << c
          lookup_data[attribute_id] = categories.size - 1
        end
      end
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
    list.map do |cat|
      {"de" => cat}
    end
  end

end