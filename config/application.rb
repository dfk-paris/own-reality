require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << "#{Rails.root}/lib"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_dispatch.perform_deep_munge = false

    config.assets.precompile += ["dfk.css"]
  end
end

# TODO: fix css scopes within riot tags to include [riot-tag=tag-name] selectors
# TODO: url on source detail modal view
# TODO: add correct dating within citations
# TODO: are there journals with different titles for some locales?
# TODO: cleanup controllers and actions
# TODO: interview 23261 files in proweb fucked up?
# TODO: rename tags
# TODO: write XML export and re-import
# TODO: fix attr search criteria replace
# TODO: include errors from proweb module into anomaly log (bin/entires and bin/attribs)
# TODO: remove comments everywhere
# TODO: unify event naming, possibly with attributes on tags publish/subscribe