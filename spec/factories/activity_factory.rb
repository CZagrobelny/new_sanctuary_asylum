FactoryBot.define do
  factory :activity do
    association :friend
    association :location
    association :region
    association :activity_type
    occur_at { 1.day.from_now }
  end
end
