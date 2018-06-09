require 'csv'
desc 'Invite users'
task invite_users: :environment do
  CSV.foreach('processed_emails.csv') do |row|
    email = row[0].strip
    unless User.where(email: email).first.present?
      User.invite!(email: email)
      puts "Inviting #{email}"
    end
  end
end

desc 'de-dup emails'
task dedup_emails: :environment do
  do_not_email = []
  all_emails = []
  CSV.foreach('accompaniments_volunteers_for_import.csv') do |row|
    email = row[0]
    status = row[1]
    all_emails << email
    do_not_email << email if %w[unsubscribed bounced].include?(status)
  end

  puts "All emails #{all_emails.count}"
  all_unique_emails = all_emails.uniq
  puts "All unique emails #{all_unique_emails.count}"
  do_not_email = do_not_email.uniq
  puts "Do not email emails #{do_not_email.count}"

  uniq_valid_emails = all_unique_emails - do_not_email

  CSV.open('processed_emails.csv', 'wb') do |csv|
    uniq_valid_emails.each do |email|
      csv << [email]
    end
  end
end
