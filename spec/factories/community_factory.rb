FactoryGirl.define do
  factory :community do
    name { FFaker::Address.city }
    slug { name.downcase.gsub(/[^a-z]/i, '') }
    association :region
  end

  trait :primary do
    primary true
  end
end