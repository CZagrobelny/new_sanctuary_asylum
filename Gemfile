source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails', '~> 6.0.3.3'

gem 'american_date' # this gives us the `to_date` method that we use in several places
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'chartkick'
gem 'devise'
gem 'devise-authy'
gem 'devise_invitable'
gem 'devise-security'
gem 'faker' # used for seed data on staging
gem 'filterrific'
gem 'geography_helper'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg'
gem 'pg_search'
gem 'puma', '~> 4.x'
gem 'rollbar'
gem 'sass-rails', '~> 5.x'
gem 'select2-rails'
gem 'simple_calendar'
gem 'timecop' # used for seed data on staging
gem 'turbolinks', '~> 5.x'
gem 'will_paginate'

group :development, :test do
  gem 'bundler-audit'
  gem 'byebug'
  gem 'capybara', require: false
  gem 'capybara-select-2'
  gem 'database_cleaner', require: false
  gem 'dotenv-rails'
  gem 'factory_bot_rails', require: false
  gem 'rspec-rails', require: false
  gem 'rubocop'
  gem 'selenium-webdriver', '3.141.0' # version locked bc/ https://stackoverflow.com/questions/56445641/ruby-watir-selenium-webdriver-depricated-warning/
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webdrivers'
  gem 'webmock', '~> 2.1', require: false
end

group :production do
  gem 'rack-attack'
  gem 'sendgrid-ruby'
  gem 'skylight'
end

group :development do
  gem 'brakeman'
  gem 'listen'
  gem 'tocer', '~> 9.1' # used for the table of contents in our Readme
end

