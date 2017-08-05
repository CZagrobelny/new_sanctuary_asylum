require 'csv'
desc 'Import friends'
task :import_friends => :environment do
  CSV.foreach("friends.csv") do |row|
    friend = Friend.new
    friend.first_name = row[0].titlecase.strip if row[0].present?
    friend.last_name = row[1].titlecase.strip if row[1].present?
    if row[2].present?
      friend.a_number = row[2].gsub(/[^0-9]/, "")
    else
      friend.no_a_number = true
    end
    friend.gender = row[4].downcase if row[4].present?
    friend.ethnicity = row[5].downcase if row[5].present?
    if row[6].present?
      row[6].split(',').each do |language_name|
        language = Language.where(name: language_name.titlecase).first
        friend.languages << language if language.present?
      end
    end
    if row[7].present?
      friend.date_of_birth = Date.strptime(row[7], '%m/%d/%Y')
    end
    friend.notes = row[8] if row[8].present?
    friend.save
    puts "created friend #{friend.inspect}"
  end
end

task :map_country_of_origin => :environment do
  CSV.foreach("country_of_origin_mapping.csv") do |row|
    if row[0].present?
      if row[1].present?
        a_number = row[1].gsub(/[^0-9]/, "")
        friend = Friend.where(a_number: a_number).first
      else
        first_name = row[2].present? ? row[2].titlecase.strip : nil
        last_name = row[3].present? ? row[3].titlecase.strip : nil
        friend = Friend.where(first_name: first_name, last_name: last_name).first
      end

      if friend.present?
        country_name = row[0].titlecase.strip
        country_of_origin = Country.where(name: country_name).first
        if country_of_origin.present?
          friend.country_id = country_of_origin.id
          friend.save
        else
          puts "Country #{country_name} not found"
        end
      else
        puts "Friend could not be found for #{row}"
      end
    end
  end
end

task :import_lawyers => :environment do
  CSV.foreach("lawyers.csv") do |row|
    lawyer = Lawyer.new
    lawyer.email = row[0] if row[0].present?
    lawyer.first_name = row[1] if row[1].present?
    lawyer.last_name = row[2] if row[2].present?
    lawyer.organization = row[3] if row[3].present?
    lawyer.phone_number = row[4] if row[4].present?
    lawyer.save
  end
end