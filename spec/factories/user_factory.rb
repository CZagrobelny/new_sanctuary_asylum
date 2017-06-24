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
  end

  trait :admin do
    role :admin
  end

  trait :volunteer do
  	role :volunteer
  end
end