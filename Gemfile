source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'jbuilder', '~> 2.0'
gem 'httpclient', '~> 2.6'
gem 'puma'
gem 'rack-cors', :require => 'rack/cors'

group :import do
  # source 'https://gems.dfkg.org' do
  #   gem 'proweb'
  # end
  gem 'proweb', path: '/home/schepp/Desktop/dev/proweb/src'
  gem 'ruby-progressbar'
end

group :development, :test do
  gem 'spring', '1.3.6'
  gem 'pry'
  gem 'method_profiler'
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
end
