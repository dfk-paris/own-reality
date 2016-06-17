namespace :or do
  task to_json: :environment do
    OwnReality::JsonExport.new.run
  end
end