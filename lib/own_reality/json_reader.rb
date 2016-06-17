class OwnReality::JsonReader

  def initialize(base_dir = 'json')
    @base_dir = base_dir
  end

  def each_interview
    data = read('interviews.data.json')
    bar = OwnReality.progress_bar :title => "caching interviews", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_article
    data = read('articles.data.json')
    bar = OwnReality.progress_bar :title => "caching articles", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_magazine
    data = read('magazines.data.json')
    bar = OwnReality.progress_bar :title => "caching magazines", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_chrono
    data = read('chronology.data.json')
    bar = OwnReality.progress_bar :title => "caching chronology", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_source
    data = read('sources.data.json')
    bar = OwnReality.progress_bar :title => "caching sources", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_person
    data = read('people.data.json')
    bar = OwnReality.progress_bar :title => "caching people", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def each_attrib
    data = read('attribs.data.json')
    bar = OwnReality.progress_bar :title => "caching attributes", :total => data.count
    data.each do |i|
      yield i
      bar.increment
    end
  end

  def config
    read('config.data.json')
  end

  protected

    def read(file)
      JSON.parse File.read("#{@base_dir}/#{file}")
    end

end