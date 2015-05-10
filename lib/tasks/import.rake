namespace :or do
  desc "import all OwnReality data"
  task :import => :environment do
    OwnReality::Importer.new.run
  end

  desc "make a test query"
  task :query => :environment do
    puts OwnReality::Importer.new.search
  end
end