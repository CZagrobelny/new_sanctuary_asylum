FactoryGirl.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.safe_email }
    phone { FFaker::PhoneNumber.short_phone_number }
    volunteer_type { 1 }
    password { FFaker::Internet.password }
    password_confirmation { password }
    invitation_accepted_at { Time.now }
    pledge_signed true
  end

  trait :admin do
    role :admin
  end

  trait :volunteer do
  	role :volunteer
  end

  trait :accompaniment_leader do
    role :accompaniment_leader
  end

  trait :unconfirmed do
    first_name nil
    last_name nil
    email { FFaker::Internet.safe_email }
    phone nil
    volunteer_type nil
    password nil
    password_confirmation nil
    invitation_accepted_at nil
    invitation_token '1gFcPwUnKCzzuntMepu1'
    invitation_created_at Time.now
    invitation_sent_at Time.now
  end 
end