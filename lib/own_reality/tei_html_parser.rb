require 'tmpdir'
require 'nokogiri'

class OwnReality::TeiHtmlParser

  def initialize(id, lang)
    @id = id
    @lang = lang
  end

  def base_path
    @base_path ||= begin
      candidates = Dir["#{OwnReality.config['proweb']['files']['html']}/#{@id}_#{@lang}_*"]

      if candidates.size != 1
        OwnReality.log_anomaly(
          "retrieving html (#{@lang})",
          "proweb-object",
          @id,
          "there is more or less than one directory candidate (#{candidates.size})"
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
        candidates = Dir["#{base_path}/XML/HTML5/*.html"]

        if candidates.size != 1
          OwnReality.log_anomaly(
            "retrieving html (#{@lang})",
            "proweb-object",
            @id,
            "there is more or less than one html file candidate (#{candidates.size})"
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