require 'tmpdir'
require 'nokogiri'

class OwnReality::TeiHtmlParser

  def initialize(id, lang)
    @id = id
    @lang = lang
  end

  def base_path
    @base_path ||= begin
      candidates = (
        Dir["#{OwnReality.config['proweb']['files']['html']}/#{@id}_#{@lang}_*"] + 
        Dir["#{OwnReality.config['proweb']['files']['html']}/#{@id}_*"]
      )

      if candidates.empty?
        OwnReality.log_anomaly(
          "retrieving html (#{@lang})",
          "proweb-object",
          @id,
          "there is no directory available to retrieve html from: #{@id}, #{@lang}"
        )
        nil
      else
        candidates.first
      end
    end
  end

  def html_file
    if base_path
      @html_file ||= begin
        candidates = (
          Dir["#{base_path}/XML/HTML5/*.html"] +
          Dir["#{base_path}/XML/XHTML/*.html"]
        )

        if candidates.empty?
          OwnReality.log_anomaly(
            "retrieving html (#{@lang})",
            "proweb-object",
            @id,
            "there is no html file available (#{base_path})"
          )
          nil
        else
          candidates.first
        end
      end
    end
  end

  def html
    if html_file
      html_string = File.read(html_file)
      doc = Nokogiri::HTML(html_string)
      doc.css('article').to_s
    end
  end

end