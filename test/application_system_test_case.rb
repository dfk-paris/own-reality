# require "test_helper"

require_relative '../config/environment'

require 'capybara/dsl'
require 'webdrivers/chromedriver'

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  [
    'headless',
    'window-size=1600x900',
    'remote-debugging-address=0.0.0.0',
    'remote-debugging-port=9222'
  ].each{|a| options.add_argument(a)}

  # set download path
  path = Rails.root.join('tmp', 'test_downloads')
  system "mkdir -p '#{path}'"
  options.add_preference 'download.default_directory', path

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

if ENV['HEADLESS']
  Capybara.current_driver = :headless_chrome
else
  Capybara.current_driver = :selenium_chrome
end

Capybara.configure do |c|
  c.default_max_wait_time = 5
end

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include Capybara::DSL

  def setup
    visit app_url
    current_window.resize_to 1600, 900
    header = find('.or-search-header', text: /Suchergebnisse/)
    scroll_to header
  end

  def app_url
    'https://dfk-paris.org/de/page/ownrealitydatenbank-und-recherche-1353.html'
  end

  def project_url
    'https://dfk-paris.org/de/ownreality'
  end
end
