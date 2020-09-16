FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.safe_email }
    phone { Faker::PhoneNumber.phone_number }
    password { (Faker::Food.fruits + Faker::PhoneNumber.area_code.to_s + Faker::Food.spice).delete(' ') }
    password_confirmation { password }
    invitation_accepted_at { Time.now }
    pledge_signed { true }
    association :community
  end

  trait :community_admin do
    role { :admin }
  end

  trait :volunteer do
  	role { :volunteer }
  end

  trait :accompaniment_leader do
    role { :accompaniment_leader }
  end

  trait :regional_admin do
    role { :admin }
    after(:create) do |regional_admin|
      create(:user_region, user: regional_admin, region: regional_admin.community.region)
    end
  end

  trait :remote_clinic_lawyer do
    role { :remote_clinic_lawyer }
  end

  trait :unconfirmed do
    first_name { nil }
    last_name { nil }
    email { Faker::Internet.unique.safe_email }
    phone { nil }
    password { nil }
    password_confirmation { nil }
    invitation_accepted_at { nil }
    invitation_token { '1gFcPwUnKCzzuntMepu1' }
    invitation_created_at { Time.now }
    invitation_sent_at { Time.now }
  end
end
