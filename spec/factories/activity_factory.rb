FactoryGirl.define do
  factory :activity do
    association :friend
    association :location
    event 1
    occur_at 1.day.from_now
  end
end