FactoryBot.define do
  factory :judge do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    hidden { false }
    association :region
  end
end
