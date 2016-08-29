require "spreadsheet"

class OwnReality::TranslatorsReader

  def self.from_file
    data = OwnReality.http_client.get_content(OwnReality.config["translators_file"])
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

        if record['id'].present? && record['lang'].present?
          records << record
        end
      end
    end

    data = {}

    records.each do |r|
      data[r['id']] ||= {}
      data[r['id']][r['lang'].downcase] = {
        'description' => r['desc'],
        'name' => r['name']
      }
    end

    new(data)
  end

  def initialize(data = {})
    @data = data
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