FactoryGirl.define do
  factory :community do
    name 'NYC'
    slug 'nyc'
    association :region
  end
end