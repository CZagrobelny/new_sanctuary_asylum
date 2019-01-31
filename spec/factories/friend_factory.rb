FactoryGirl.define do
  factory :friend do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    a_number { rand.to_s[2..10] }
    association :community
    association :region
  end
end
