require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewSanctuaryAsylum
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

		#Allow the app to controll it's own error routes (custom 404, etc.)
		#NOTE:and app erros will still cause the server env to handle errors (Heroku), so these routes are only effective when the app is running
	config.exceptions_app = self.routes
    if !Rails.env.development? && !Rails.env.test?
      config.middleware.use Rack::Attack
    end
  end
end
