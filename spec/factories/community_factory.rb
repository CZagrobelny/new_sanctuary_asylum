FactoryGirl.define do
  factory :community do
    name { FFaker::Address.city }
    slug { name.downcase.gsub(' ', '-') }
    association :region
  end
end