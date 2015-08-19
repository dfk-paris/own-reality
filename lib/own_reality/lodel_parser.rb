class OwnReality::LodelParser

  def initialize(url)
    @url = url
  end

  def parse
    tmp_uri = URI.parse(@url)

    response = HTTPClient.new.request "get", @url

    if response.status == 200
      doc = Nokogiri.parse(response.body)
      out = doc.css("div.article#content").first
      out.css("img").each do |img|
        img["src"] = "#{@url.split(/\/[^\/]*$/).first}/#{img['src']}"
      end
      out.to_html
    else
      puts "#{@url} couldn't be fetched: #{response.status}"
      nil
    end
  rescue URI::InvalidURIError => e
    puts "invalid url '#{@url}'"
    nil
  end

end