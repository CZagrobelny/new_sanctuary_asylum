FactoryGirl.define do
  factory :sanctuary do
    name { Faker::Name.name }
    leader_name { Faker::Name.name }
    association :community
  end
end
