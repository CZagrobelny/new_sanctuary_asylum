FactoryBot.define do
  factory :location do
  	name { Faker::Address.street_address }
    association :region
  end
end