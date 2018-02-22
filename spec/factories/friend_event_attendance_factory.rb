FactoryGirl.define do
  factory :friend_event_attendance do
    association :friend
    association :event
  end
end