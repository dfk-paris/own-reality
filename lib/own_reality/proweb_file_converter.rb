class OwnReality::ProwebFileConverter

  def initialize(proweb_id)
    @proweb_id = proweb_id
  end

  def pdfs_by_locale
    results = {}
    ['fr', 'de', 'en', 'pl'].each do |lang|
      if f = OwnReality.k_files["pdf_#{lang}_#{@proweb_id}"]
        target = "#{original_dir}/original_#{lang}.pdf"
        unless File.exists?(target)
          system "cp \"#{f}\" #{target}"
        end
        public_target = "#{public_dir}/original_#{lang}.pdf"
        unless File.exists?(public_target)
          system "ln -sfn #{target} #{public_target}"
        end
        results[lang] = "files/#{hash}/original_#{lang}.pdf"
      end
    end

    if results.keys.empty?
      OwnReality.log_anomaly(
        "finding pdfs for paper",
        "proweb-id",
        @proweb_id,
        "no pdfs found"
      )
    end

    results
  end

  def cover
    if cover = Dir["#{original_dir}/*Cover*.jpg"].first
      system "cp #{cover} #{public_dir}/cover.jpg"
      hash
    end
  end

  def merge_files
    if has_files?
      combine
      shrink
      
      hash
    end
  end

  def original_dir
    @original_dir ||= begin
      path = "#{Proweb.config['files']['target']}/#{@proweb_id}"
      Pathname.new(path).realpath
    rescue Errno::ENOENT => e
      nil 
    end
  end

  def public_dir
    path = "#{Proweb.config['files']['public']}/#{hash}"
    system "mkdir -p #{path}"
    @public_dir ||= Pathname.new(path).realpath
  rescue Errno::ENOENT => e
    nil 
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
      f = File.readlink(f) if File.symlink?(f)
      File.stat(f).mtime.to_s
    end.join
  end

  def hash(data = nil)
    data ||= hash_base
    @hash ||= Digest::SHA1.hexdigest(data)
  end

  def safe_files(files)
    files.map do |f|
      "\"#{f}\""
    end.join(' ')
  end

  def has_files?
    public_dir && original_dir && File.exists?(original_dir) && !original_files.empty?
  end

  def combine
    original = "#{public_dir}/original.pdf"
    unless File.exists?(original)
      system "mkdir -p #{public_dir}"
      command = if original_files.all?{|f| f.match(/\.pdf$/i)}
        if original_files.size == 1
          "ln -sfn \"#{original_files.first}\" #{original}"
        else
          "pdftk #{safe_files original_files} cat output #{original}"  
        end
      else
        "convert #{safe_files original_files} #{original}"
      end
      # puts command
      result = run command
      unless result[:status] == 0
        OwnReality.log_anomaly(
          "combining pdfs",
          "command on file",
          command,
          result[:stderr]
        )
      end
    end
  end

  def shrink(lang = nil)
    ls = (lang ? '_' + lang : nil)
    original = "#{public_dir}/original#{ls}.pdf"

    if File.exists?(original)
      resolutions.each do |r|
        target = "#{public_dir}/#{r}#{ls}.jpg"
        unless File.exists?(target)
          command = "convert #{original}[0] -resize \"#{r}x#{r}>\" -alpha remove #{target}"
          result = run command
          unless result[:status] == 0
            OwnReality.log_anomaly(
              "shrinking pdfs",
              "command on file",
              command,
              result[:stderr]
            )
          end
        end
      end
    end
  end

  def run(command)
    rout, wout = IO.pipe
    rerr, werr = IO.pipe
    pid = Process.spawn(command, out: wout, err: werr)
    Process.wait(pid)
    status = $?
    wout.close
    werr.close
    {stdout: rout.read, stderr: rerr.read, status: status.to_i}
  end

end

