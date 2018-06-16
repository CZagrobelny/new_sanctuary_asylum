require 'ffaker'
##Populate Countries and Languages
Rake::Task['populate_countries'].invoke
Rake::Task['populate_languages'].invoke

#Admin User
User.create(first_name: 'Admin', last_name: 'Admin', email: 'admin@example.com', phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)

#Accompaniment Leader User
User.create(first_name: 'Accompaniment', last_name: 'Leader', email: 'accompaniment_leader@example.com', phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1, pledge_signed: true)

#Volunteer User
User.create(first_name: 'Volunteer', last_name: 'Volunteer', email: 'volunteer@example.com', phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)

#Some additional volunteer users
30.times do
  User.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.safe_email, phone: FFaker::PhoneNumber.short_phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)
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
    date_of_entry: FFaker::Time.between(1.day.ago, 5.years.ago),
    notes: FFaker::Lorem.paragraph,
    asylum_status: ['not_eligible', 'eligible', 'application_started'].sample,
    asylum_notes: FFaker::Lorem.paragraph,
    lawyer_notes: FFaker::Lorem.paragraph,
    work_authorization_notes: FFaker::Lorem.paragraph,
    work_authorization_status: ['not_eligible', 'eligible', 'application_started'].sample,
    sijs_status: ['not_eligible', 'eligible', 'application_started'].sample,
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
Location.create(name: 'Judson')
Location.create(name: 'Varick St')

#Judges
Judge.create(first_name: 'Ruth', last_name: 'Bader Ginsburg')
Judge.create(first_name: 'Sonia', last_name: 'Sotomayor')
Judge.create(first_name: 'Elena', last_name: 'Kagan')

#Activities
Friend.all[0..25].each do |friend|
  friend.activities.create(
    event: ['check_in', 'master_calendar_hearing', 'individual_hearing'].sample,
    location_id: Location.first.id,
    judge_id: Judge.first.id,
    occur_at: FFaker::Time.between(1.month.ago, 1.month.from_now),
    notes: FFaker::Lorem.paragraph)
end

##Accompaniments
Activity.all.each do |activity|
  activity.accompaniments.create(user_id: User.order("RANDOM()").first.id)
end

#Events
30.times do |t|
  Event.create(location: Location.order("RANDOM()").first,
              category: Event::CATEGORIES.sample[0],
              date: FFaker::Time.between(2.months.ago, 2.months.from_now),
              title: "Test Event #{t}")
end

Event.all.each do |event|
  event.user_event_attendances.create(user_id: User.order("RANDOM()").first.id)
  event.friend_event_attendances.create(friend_id: Friend.order("RANDOM()").first.id)
end

#Detentions
Friend.all[0..25].each_with_index do |friend, index|
  is_released = index % 5 == 0
  date_released = is_released ? FFaker::Time.between(1.month.from_now, 1.month.ago) : nil
  friend.detentions.create(
    date_detained: FFaker::Time.between(8.months.ago, 7.months.ago),
    date_released: date_released,
    case_status: ['immigration_court', 'bia', 'circuit_court'].sample,
    location_id: Location.last.id,
    notes: FFaker::Lorem.paragraph)
end
