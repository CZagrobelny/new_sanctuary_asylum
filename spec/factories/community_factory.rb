FactoryGirl.define do
  factory :community do
    name { Faker::Address.city }
    slug { name.downcase.gsub(/[^a-z]/i, '') }
    association :region
  end

  trait :primary do
    primary true
  end
end