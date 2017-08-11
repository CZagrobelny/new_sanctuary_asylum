require 'csv'
desc 'Invite users'
task :import_friends => :environment do
  CSV.foreach("new_users.csv") do |row|
    email = row[0].strip
    User.invite!(:email => email)
    puts 'Inviting #{email}'
  end
end
