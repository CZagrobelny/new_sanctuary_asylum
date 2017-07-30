require 'ffaker'
##Populate Countries and Languages
Rake::Task['populate_countries'].invoke
Rake::Task['populate_languages'].invoke

#Admin User
User.create(first_name: 'Admin', last_name: 'Admin', email: 'admin@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1)

#Volunteer User
User.create(first_name: 'Volunteer', last_name: 'Volunteer', email: 'volunteer@example.com', phone: '888 888 8888', password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0)

#Some additional volunteer users
30.times do
  User.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.safe_email, phone: FFaker::PhoneNumber.short_phone_number, password: 'password', password_confirmation: 'password', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0)
end

#Friends
30.times do
  Friend.create(first_name: FFaker::Name.first_name, 
    last_name: FFaker::Name.last_name, 
    a_number: rand.to_s[2..10], 
    middle_name: FFaker::Name.first_name,
    email: FFaker::Internet.safe_email,
    phone: FFaker::PhoneNumber.short_phone_number,
    ethnicity: ['white', 'black', 'hispanic', 'asian', 'south_asian', 'caribbean', 'indigenous'].sample,
    gender: ['male', 'female', 'awesome'].sample,
    date_of_birth: FFaker::Time.between(10.years.ago, 40.years.ago), 
    status: 'not_in_deportation_proceedings',
    date_of_entry: FFaker::Time.between(10.years.ago, 40.years.ago),
    notes: FFaker::Lorem.paragraph,
    asylum_status: ['asylum_not_eligible', 'asylum_eligible', 'asylum_application_started'].sample,
    asylum_notes: FFaker::Lorem.paragraph,
    lawyer_notes: FFaker::Lorem.paragraph,
    work_authorization_notes: FFaker::Lorem.paragraph,
    work_authorization_status: ['work_authorization_not_eligible', 'work_authorization_eligible', 'work_authorization_application_started'].sample,
    sijs_status: ['sijs_not_eligible', 'sijs_eligible', 'sijs_application_started'].sample,
    sijs_notes: FFaker::Lorem.paragraph,
    country_id: Country.order("RANDOM()").first.id,
    language_ids: [Language.order("RANDOM()").first.id],
    user_ids: User.order("RANDOM()").limit(5).map(&:id)
    )
end

#Lawyers
Lawyer.create(first_name: 'Michelle', last_name: 'Obama')
Lawyer.create(first_name: 'Arrabella', last_name: 'Mansfield')
Lawyer.create(first_name: 'Amal', last_name: 'Clooney')
Lawyer.create(first_name: 'Hillary', last_name: 'Rodham')

#Locations
Location.create(name: '26 Federal Plaza')

#Judges
Judge.create(first_name: 'Ruth', last_name: 'Bader Ginsburg')
Judge.create(first_name: 'Sonia', last_name: 'Sotomayor')
Judge.create(first_name: 'Elena', last_name: 'Kagan')

#Activities
Friend.all[0..25].each do |friend|
  friend.activities.create(
    event: ['check_in', 'master_calendar_hearing', 'individual_hearing'].sample,
    location_id: Location.first.id,
    friend_id: Friend.order("RANDOM()").first.id,
    judge_id: Judge.first.id,
    occur_at: FFaker::Time.between(1.month.ago, 1.month.from_now),
    notes: FFaker::Lorem.paragraph)
end

##Accompaniements
Activity.all.each do |activity|
  activity.accompaniements.create(user_id: User.order("RANDOM()").first.id)
end

#Events
Event.create(location: Location.first, 
             category: 'asylum_workshop', 
             date: Time.now + 3.days, 
             title: 'Asylum Workshop') 

Event.create(location: Location.first, 
             category: 'accompaniment_training', 
             date: Time.now + 2.days, 
             title: 'Training for Everyone') 
