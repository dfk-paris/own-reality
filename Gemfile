source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'uglifier', '>= 1.3.0'
gem 'less-rails', '~> 2.7'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'httpclient', '~> 2.6'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'font-awesome-rails'

group :import do
  if File.exists?("/var/storage/host/own_reality/shared/proweb")
    gem 'proweb', :path => "/var/storage/host/own_reality/shared/proweb"
  else
    gem 'proweb', :path => "/home/schepp/Desktop/mws/projects/proweb/src"
  end

  if File.exists?("/var/storage/host/own_reality/shared/dfk")
    gem 'dfk', :path => "/var/storage/host/own_reality/shared/dfk"
  else
    gem 'dfk', :path => "/home/schepp/Desktop/mws/projects/scripts/src/dfk"
  end
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring', '1.3.6'
  gem 'pry'
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'capybara'
end
