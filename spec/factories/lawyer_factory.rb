FactoryGirl.define do
  factory :lawyer do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    association :region
  end
end