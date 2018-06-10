require 'ffaker'
##Populate Countries and Languages
Rake::Task['populate_countries'].invoke
Rake::Task['populate_languages'].invoke

# NY Region
ny_region = Region.create(name: 'ny')

# Florida Region
fl_region = Region.create(name: 'fl')

# Primary community (NYC)
nyc_community = Community.create(name: 'NYC',
                                slug: 'nyc',
                                region_id: ny_region.id,
                                primary: true)

# NON-primary community (Long Island)
long_island_community = Community.create(name: 'Long Island',
                                        slug: 'long-island',
                                        region_id: ny_region.id,
                                        primary: false)

# Primary community (Tampa)
tampa_community = Community.create(name: 'Tampa',
                                slug: 'tampa',
                                region_id: fl_region.id,
                                primary: true)

# NY Regional admin
ny_regional_admin = User.create(first_name: 'NY Regional', last_name: 'Admin', email: 'ny_regional_admin@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)
ny_regional_admin.user_regions.create(region_id: ny_region.id)

## NYC Users

#Accompaniment Leader User
User.create(first_name: 'NYC Accompaniment', last_name: 'Leader', email: 'nyc_accompaniment_leader@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1, pledge_signed: true)

#Volunteer User
User.create(first_name: 'NYC Community', last_name: 'Volunteer', email: 'nyc_volunteer@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)

#Admin User
User.create(first_name: 'NYC Community', last_name: 'Admin', email: 'nyc_admin@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)

#Some additional NYC volunteer users
30.times do
  User.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.safe_email, community_id: nyc_community.id, phone: FFaker::PhoneNumber.short_phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)
end

## Long Island Users

#Accompaniment Leader User
User.create(first_name: 'LI Accompaniment', last_name: 'Leader', email: 'li_accompaniment_leader@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1, pledge_signed: true)

#Volunteer User
User.create(first_name: 'LI Community', last_name: 'Volunteer', email: 'li_volunteer@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)

#Admin User
User.create(first_name: 'LI Community', last_name: 'Admin', email: 'li_admin@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)

#Some additional Long Island volunteer users
30.times do
  User.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.safe_email, community_id: long_island_community.id, phone: FFaker::PhoneNumber.short_phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)
end

# NYC Friends
30.times do
  Friend.create(first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    a_number: rand.to_s[2..10],
    community_id: nyc_community.id,
    region_id: ny_region.id,
    middle_name: FFaker::Name.first_name,
    email: FFaker::Internet.safe_email,
    phone: FFaker::PhoneNumber.short_phone_number,
    ethnicity: ['white', 'black', 'hispanic', 'asian', 'south_asian', 'caribbean', 'indigenous'].sample,
    gender: ['male', 'female', 'awesome'].sample,
    date_of_birth: FFaker::Time.between(10.years.ago, 40.years.ago),
    status: 'not_in_deportation_proceedings',
    date_of_entry: FFaker::Time.between(10.years.ago, 40.years.ago),
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
    user_ids: User.where(community_id: nyc_community.id).order("RANDOM()").limit(5).map(&:id)
    )
end

# Long Islang Friends
30.times do
  Friend.create(first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    a_number: rand.to_s[2..10],
    community_id: long_island_community.id,
    region_id: ny_region.id,
    middle_name: FFaker::Name.first_name,
    email: FFaker::Internet.safe_email,
    phone: FFaker::PhoneNumber.short_phone_number,
    ethnicity: ['white', 'black', 'hispanic', 'asian', 'south_asian', 'caribbean', 'indigenous'].sample,
    gender: ['male', 'female', 'awesome'].sample,
    date_of_birth: FFaker::Time.between(10.years.ago, 40.years.ago),
    status: 'not_in_deportation_proceedings',
    date_of_entry: FFaker::Time.between(10.years.ago, 40.years.ago),
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
    user_ids: User.where(community_id: long_island_community.id).order("RANDOM()").limit(5).map(&:id)
    )
end

#Lawyers
Lawyer.create(first_name: 'Michelle', last_name: 'Obama', region_id: ny_region.id)
Lawyer.create(first_name: 'Arrabella', last_name: 'Mansfield', region_id: ny_region.id)
Lawyer.create(first_name: 'Amal', last_name: 'Clooney', region_id: ny_region.id)
Lawyer.create(first_name: 'Hillary', last_name: 'Rodham', region_id: ny_region.id)

#Locations
Location.create(name: '26 Federal Plaza', region_id: ny_region.id)
Location.create(name: 'Judson', region_id: ny_region.id)
Location.create(name: 'Varick St', region_id: ny_region.id)

#Judges
Judge.create(first_name: 'Ruth', last_name: 'Bader Ginsburg', region_id: ny_region.id)
Judge.create(first_name: 'Sonia', last_name: 'Sotomayor', region_id: ny_region.id)
Judge.create(first_name: 'Elena', last_name: 'Kagan', region_id: ny_region.id)

#Activities
Friend.all.each do |friend|
  friend.activities.create(
    event: ['check_in', 'master_calendar_hearing', 'individual_hearing'].sample,
    location_id: Location.first.id,
    judge_id: Judge.first.id,
    occur_at: FFaker::Time.between(1.month.ago, 1.month.from_now),
    notes: FFaker::Lorem.paragraph,
    region_id: ny_region.id)
end

##Accompaniments
Activity.all.each do |activity|
  activity.accompaniments.create(user_id: User.where(community_id: nyc_community.id).order("RANDOM()").first.id)
end

#Events
30.times do |t|
  Event.create(location: Location.order("RANDOM()").first,
              category: Event::CATEGORIES.sample[0],
              date: FFaker::Time.between(2.months.ago, 2.months.from_now),
              title: "Test Event #{t}",
              community_id: nyc_community.id)
end

Event.all.each do |event|
  event.user_event_attendances.create(user_id: User.where(community_id: nyc_community.id).order("RANDOM()").first.id)
  event.friend_event_attendances.create(friend_id: Friend.where(community_id: nyc_community.id).order("RANDOM()").first.id)
end

#Detentions
Friend.all[0..25].each do |friend|
  friend.detentions.create(
    date_detained: FFaker::Time.between(8.months.ago, 7.months.ago),
    date_released: FFaker::Time.between(1.months.ago, 2.months.ago),
    case_status: ['immigration_court', 'bia', 'circuit_court'].sample,
    location_id: Location.last.id,
    notes: FFaker::Lorem.paragraph)
end

#Sanctuaries
10.times do
  Sanctuary.create(name: FFaker::Company.name,
                    address: FFaker::Address.street_address,
                    city: 'New York',
                    state: 'NY',
                    zip_code: '10001',
                    leader_name:  FFaker::Name.name,
                    leader_email: FFaker::Internet.safe_email,
                    leader_phone_number: FFaker::PhoneNumber.short_phone_number,
                    community_id: nyc_community.id)
end
