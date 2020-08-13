require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewSanctuaryAsylum
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Eastern Time (US & Canada)'

    # Allow the app to control its own error routes (custom 404, etc.)
    # NOTE: and app errors will still cause the server env to handle errors (Heroku),
    # so these routes are only effective when the app is running
    config.exceptions_app = self.routes

    if !Rails.env.development? && !Rails.env.test?
      config.middleware.use Rack::Attack
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
