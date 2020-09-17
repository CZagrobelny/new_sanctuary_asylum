FactoryBot.define do
  factory :friend do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    a_number { Faker::Number.unique.number(digits: 9).to_s }
    gender { %w[male female awesome].sample }
    association :community
    association :region
  end
end
