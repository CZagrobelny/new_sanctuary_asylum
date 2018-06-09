FactoryGirl.define do
  factory :region do
    name { FFaker::Company.name.downcase.gsub(/[^a-z]/i, '') }
  end
end
