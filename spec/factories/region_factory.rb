FactoryGirl.define do
  factory :region do
    name { Faker::Company.name.downcase.gsub(/[^a-z]/i, '') }
  end
end
