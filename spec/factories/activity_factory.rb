FactoryGirl.define do
  factory :activity do
    association :friend
    association :location
    association :region
    event 'master_calendar_hearing'
    occur_at 1.day.from_now
  end
end