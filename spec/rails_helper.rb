# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'faker'

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'launchy'

require 'support/wait_for_ajax'
require 'support/select_from_chosen'

Faker::Config.locale = 'en-US'
Capybara.javascript_driver = :poltergeist
Phantomjs.path
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    js_errors: false,
    debug: false,
    inspect: false,
    phantomjs_options: ['--ssl-protocol=any'],
    :phantomjs => Phantomjs.path
  })
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Rails.application.routes.url_helpers
  config.include WaitForAjax, type: :feature
  ##Helper to select from chosen js dropdowns
  config.include Select, type: :feature

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:each) do
    Faker::UniqueGenerator.clear
  end

  config.before(:each) do
    Rails.application.routes.default_url_options[:host] = 'test.host'
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  #
  # Database Cleaner
  #
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :type => :feature) do
    driver_shared_db_connection = (Capybara.current_driver == :rack_test)

    unless driver_shared_db_connection
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end


  #
  # Wait longer for certain feature specs
  #
  config.before(:each, wait_longer: true) do
    @_original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 8

    Rails.logger.info "=====> Capybara wait time changed from #{@_original_wait_time} to 8"
  end

  config.after(:each, wait_longer: true) do
    Capybara.default_max_wait_time = @_original_wait_time

    Rails.logger.info "=====> Capybara wait time reset to #{@original_wait_time}"
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
