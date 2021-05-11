source 'https://rubygems.org'

gem 'rails', '6.1.3.2'
gem 'jbuilder', '~> 2.0'
gem 'httpclient', '~> 2.6'
gem 'puma'
gem 'rack-cors', :require => 'rack/cors'

group :import do
  # source 'https://gems.dfkg.org' do
  #   gem 'proweb'
  # end
  # gem 'proweb', git: 'https://github.com/dfk-paris/proweb'

  # alternative: use for development, e.g. when upgrading rails
  # gem 'proweb', path: '../../proweb/src'
  gem 'ruby-progressbar'
end

group :development, :test do
  gem 'spring', '1.3.6'
  gem 'pry'
  gem 'method_profiler'
end

group :test do
  gem 'webdrivers', '~> 4.0'
  # gem 'rspec-rails'
  # gem 'cucumber-rails'
  gem 'capybara'
  # gem 'selenium-webdriver'
end
