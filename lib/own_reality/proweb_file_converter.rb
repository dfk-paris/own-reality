class OwnReality::ProwebFileConverter

  def initialize(proweb_id)
    @proweb_id = proweb_id
  end

  def original_dir
    @original_dir ||= File.expand_path("#{Proweb.config['files']['target']}/#{@proweb_id}")
  end

  def public_dir
    @public_dir ||= File.expand_path("#{Proweb.config['files']['public']}/#{hash}")
  end

  def original_files
    extensions = ["jpg", "png", "jpeg", "gif", "pdf", "bmp", "tif", "tiff"]
    Dir["#{original_dir}/*"].select do |f|
      extensions.include? f.split(".").last.downcase
    end
  end

  def resolutions
    Proweb.config["resolutions"]
  end

  def hash_base
    original_files.map do |f|
      File.stat(f).mtime.to_s
    end.join
  end

  def hash
    @hash ||= Digest::SHA1.hexdigest(hash_base)
  end

  def combine
    original = "#{public_dir}/original.pdf"
    unless File.exists?(original)
      system "mkdir -p #{public_dir}"
      unless original_files.empty?
        command = if original_files.all?{|f| f.match(/\.pdf$/i)}
          if original_files.size == 1
            "ln -sfn \"#{original_files.first}\" #{original}"
          else
            "pdftk #{safe_files original_files} cat output #{original}"  
          end
        else
          "convert #{safe_files original_files} #{original}"
        end
        puts command
        system command
      end
    end
  end

  def safe_files(files)
    files.map do |f|
      "\"#{f}\""
    end.join(' ')
  end

  def run
    combine
    shrink
    identify
  end

  def shrink
    original = "#{public_dir}/original.pdf"

    if File.exists?(original)
      resolutions.each do |r|
        target = "#{public_dir}/#{r}.jpg"
        unless File.exists?(target)
          system "convert #{original}[0] -resize \"#{r}x#{r}>\" #{target}"
        end
      end
    end
  end

  def identify
    system "touch #{public_dir}/#{@proweb_id}.info"
  end

end