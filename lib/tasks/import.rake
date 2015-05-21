require "proweb"

namespace :or do
  desc "import all OwnReality data"
  task :import => :environment do
    Proweb.config = YAML.load_file("#{Rails.root}/config/app.yml")["proweb"]
    Proweb.connect
    # Proweb::Import.new(Proweb.source, Proweb.target).run
    OwnReality::Import.new.run
  end

  desc "make a test query"
  task :query => :environment do
    Proweb.config = YAML.load_file("#{Rails.root}/config/app.yml")["proweb"]
    puts OwnReality::Import.new.search
  end
end
