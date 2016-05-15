namespace :or do

  task xml: :environment do
    results = OwnReality::Query.new.search('sources', 'per_page' => 10000)
    binding.pry


  end

end