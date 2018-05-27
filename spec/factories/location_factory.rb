FactoryGirl.define do
  factory :location do
  	name { FFaker::Address.street_address }
    association :region
  end
end