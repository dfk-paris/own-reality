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
        doc.css('img').each do |img|
          new_src = img['src'].gsub(/\.\.\/\.\.\/icono\/(hr|br)\//, "images/#{@proweb_id}/")
          unless File.exists?("#{Rails.root}/public/#{new_src}")
            OwnReality.log_anomaly(
              "images within papers",
              "proweb-id",
              @proweb_id,
              "image #{new_src} not found"
            )
          end
          img['src'] = new_src
        end
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

  def teaser
    results = {}
    ['fr', 'de', 'en', 'pl'].each do |lang|
      if f = OwnReality.k_files["html_#{lang}_#{@proweb_id}"]
        html = File.read(f)
        doc = Nokogiri::HTML(html)
        paragraphs = doc.css('article section p')
        paragraphs.css('.tonote, .manchette').remove
        teaser = []
        count = 0
        loop do
          para = paragraphs.shift
          teaser << para.to_html
          count += para.text.size
          break if count > 500
        end
        results[lang] = teaser.join
      else
        results[lang] = nil
      end
    end
    results
  end

  def copy_images(html_file)
    br = File.expand_path(File.dirname(html_file) + '/../../icono/br')
    if File.exists?(br)
      target = "#{Rails.root}/public/images/#{@proweb_id}"
      system "rsync -aq #{br}/ #{target}/"
    end
  end

end