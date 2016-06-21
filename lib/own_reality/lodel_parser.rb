require 'tmpdir'
require 'nokogiri'

class OwnReality::LodelParser

  def initialize(url)
    @url = url
  end

  def parse
    tmp_uri = URI.parse(@url)

    response = HTTPClient.new.request "get", @url

    if response.status == 200
      doc = ::Nokogiri.parse(response.body)
      out = doc.css("div.article#content").first
      out.css("img").each do |img|
        img["src"] = "#{@url.split(/\/[^\/]*$/).first}/#{img['src']}"
      end
      out.to_html
    else
      nil
    end
  rescue URI::InvalidURIError => e
    nil
  end

  def tidy(html)
    result = nil
    Dir.mktmpdir do |d|
      File.open "#{d}/in.html", "w" do |f|
        f.write html
      end
      system "tidy -i --doctype omit --show-body-only yes #{d}/in.html > #{d}/out.html"
      result = File.read "#{d}/out.html"
    end
    result
  end

end