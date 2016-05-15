class OwnReality::ProwebFileConverter

  def initialize(proweb_id)
    @proweb_id = proweb_id
  end

  def pdfs_by_locale
    results = {}
    Proweb::Object.find(@proweb_id).files.each do |file|
      l = file.split(/[_\.]/)[-2].downcase
      l = 'pl' if l == 'pol'
      h = hash(File.stat(file).mtime.to_s + file)
      dir = Pathname.new("#{Proweb.config['files']['public']}/#{h}").realpath
      system "mkdir -p #{dir}"
      system "ln -sfn \"#{file}\" \"#{dir}/original.pdf\""
      results[l] = h
    end
    results
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

  def shrink
    original = "#{public_dir}/original.pdf"

    if File.exists?(original)
      resolutions.each do |r|
        target = "#{public_dir}/#{r}.jpg"
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
    status = Process.wait(pid)
    wout.close
    werr.close
    {stdout: rout.read, stderr: rerr.read, status: status}
  end

end

