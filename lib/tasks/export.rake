namespace :or do
  namespace :export do

    task json: :environment do
      OwnReality::Export.new.json
    end

  end
end