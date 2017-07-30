FactoryGirl.define do
  factory :event do
    association :location
    title {'Title' }
    category { Event::CATEGORIES.first[0] }
    date { Time.now }
  end
end