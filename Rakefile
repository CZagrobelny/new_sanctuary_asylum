# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

if Rails.env.development?
  begin
    require "tocer/rake/setup"
  rescue LoadError => error
    puts error.message
  end
end
