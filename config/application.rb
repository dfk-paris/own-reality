require_relative "boot"

require "rails"
# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"

require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OwnReality

end

# require './lib/own_reality/attribute_categories_reader'
require './lib/own_reality/elastic'
require './lib/own_reality/import'
require './lib/own_reality/json_export'
require './lib/own_reality/json_reader'
# require './lib/own_reality/lodal_parser'
require './lib/own_reality/proweb_file_converter'
require './lib/own_reality/proweb_reader'
require './lib/own_reality/query'
require './lib/own_reality/tei_html_parser'
require './lib/own_reality/translators_reader'

module OwnReality
  
  def self.config
    @config ||= YAML.load(File.read "#{Rails.root}/config/app.yml")
  end

  def self.http_client
    @http_client ||= HTTPClient.new
  end

  def self.progress_bar(options = {})
    options.reverse_merge! :format => "%t |%B| %c/%C (+%R/s) | %a |%f"
    ProgressBar.create options
  end

  def self.log_anomaly(process, klass, id, description)
    @anomaly_logger ||= begin
      file = "#{Rails.root}/log/anomalies.log"
      system "rm -f #{file}"
      Logger.new(file)
    end

    @anomaly_logger.info "#{process}: #{klass}: #{id}: #{description}"
  end

  def self.k_files
    @k_files ||= begin
      results = {}
      
      files = Dir.glob("#{config['k_files']}/**/*.{html,pdf}", File::FNM_CASEFOLD)
      files.each do |f|
        unless f.match(/\/originaux\//)
          if m = f.match(/^.*\/(\d+)_.+_(de|fr|en|pl)\.(html|pdf)$/i)
            x, id, lang, ext = m.to_a
            results["#{ext}_#{lang}_#{id}"] = f
          end
        end
      end

      files = Dir.glob("#{config['k_files']}/**/*.{jpg,jpeg}", File::FNM_CASEFOLD)
      files.each do |f|
        unless f.match(/\/originaux\//)
          if m = f.match(/^.*\/(\d+)_[^_]+_Cover.(jpg|jpeg)$/i)
            x, id, ext = m.to_a
            results["cover_#{id}"] = f
          end
        end
      end

      results
    end
  end

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << "#{Rails.root}/lib"
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_dispatch.perform_deep_munge = false

    # config.assets.precompile += ["dfk.css"]

    config.middleware.insert_before 0, Rack::Cors, :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end
  end
end
