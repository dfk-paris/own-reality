require "proweb"

namespace :or do
  desc "import all OwnReality data"
  task :import => :environment do
    Proweb.config = YAML.load_file("#{Rails.root}/config/app.yml")["proweb"]
    Proweb.connect
    
    Proweb::Import.new(Proweb.source, Proweb.target).run
    Proweb::FileCleaner.new(OwnReality).run
    OwnReality::Import.new(OwnReality::ProwebReader.new).run
  end

  task from_json: :environment do
    OwnReality::Import.new(OwnReality::JsonReader.new).run
  end
end
