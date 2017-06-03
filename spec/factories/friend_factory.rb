FactoryGirl.define do
  factory :friend do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    a_number { rand.to_s[2..10] }
  end
end