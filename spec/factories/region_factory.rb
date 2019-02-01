FactoryGirl.define do
  factory :region do
    name { Faker::Company.unique.name.downcase.gsub(/[^a-z]/i, '') }
  end
end
