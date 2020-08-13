'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails', '~> 6.0.x'

gem 'american_date' # this gives us the `to_date` method that we use in several places
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-aws'
gem 'chartkick'
gem 'devise', '~> 4.7'
gem 'devise_invitable', '~> 1.7'
gem 'devise-security'
gem 'faker' # used for seed data on staging
gem 'filterrific', '~> 5.x'
gem 'geography_helper'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 6.0'
gem 'non-stupid-digest-assets' # TODO this is necessary for creating a new draft with an attachment, but we should try to fix it another way.
gem 'pg', '~> 1.1'
gem 'pg_search'
gem 'puma', '~> 3.x'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'select2-rails'
gem 'simple_calendar', '~> 2.0'
gem 'textacular', '~> 5.0'
gem 'timecop' # used for seed data on staging
gem 'turbolinks', '~> 5.x'
gem 'will_paginate'

group :assets do
  gem 'coffee-rails'
  gem 'sprockets'
  gem 'uglifier'
end

group :development, :test do
  gem 'bundler-audit'
  gem 'byebug'
  gem 'capybara', '~> 2.10', require: false
  gem 'capybara-email'
  gem 'database_cleaner', '~> 1.5', require: false
  gem 'dotenv-rails'
  gem 'capybara-select-2'
  gem 'factory_bot_rails', require: false
  gem 'launchy', require: false
  gem 'poltergeist', '~> 1.11', require: false
  gem 'phantomjs'
  gem 'pry'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.1', require: false
  gem 'rubocop'
  gem 'shoulda-matchers', '~> 3.1', require: false
  gem 'simplecov'
  gem 'webmock', '~> 2.1', require: false
end

group :production do
  gem 'rack-attack'
  gem 'sendgrid-ruby', '~> 5.2'
  gem 'skylight'
end

group :development do
  gem 'listen', '~> 3.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'tocer', '~> 9.1'
  gem 'web-console', '~> 3.0'
  gem 'brakeman'
end

