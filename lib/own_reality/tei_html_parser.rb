require 'tmpdir'
require 'nokogiri'

class OwnReality::TeiHtmlParser

  def initialize(id)
    @proweb_id = id
  end

  def html
    results = {}
    ['fr', 'de', 'en', 'pl'].each do |lang|
      if f = OwnReality.k_files["html_#{lang}_#{@proweb_id}"]
        copy_images(f)
        html = File.read(f)
        doc = Nokogiri::HTML(html)
        results[lang] = doc.css('article').to_s
      else
        results[lang] = nil
      end
    end

    if results.keys.empty?
      OwnReality.log_anomaly(
        "finding html for paper",
        "proweb-id",
        @proweb_id,
        "no html found"
      )
    end

    results
  end

  def copy_images(html_file)
    br = File.expand_path(File.dirname(html_file) + '../../icono/br')
    if File.exists?(br)
      target = "#{Rails.root}/public/images/#{@proweb_id}"
      system "rsync -aq #{br}/ #{target}/"
    end
  end

end