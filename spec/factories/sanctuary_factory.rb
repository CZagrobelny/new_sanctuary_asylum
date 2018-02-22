FactoryGirl.define do
  factory :sanctuary do
    name { FFaker::Name.name }
    leader_name { FFaker::Name.name }
  end
end
