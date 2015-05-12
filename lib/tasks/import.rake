require "proweb"

namespace :or do
  desc "import all OwnReality data"
  task :import => :environment do
    Proweb.config = YAML.load_file("#{Rails.root}/config/app.yml")["proweb"]
    Proweb.connect
    Proweb::Importer.new(Proweb.source, Proweb.target).run
    OwnReality::Importer.new.run
  end

  desc "make a test query"
  task :query => :environment do
    Proweb.config = YAML.load_file("#{Rails.root}/config/app.yml")["proweb"]
    puts OwnReality::Importer.new.search
  end
end