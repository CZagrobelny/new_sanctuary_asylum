FactoryGirl.define do
  factory :friend_event_attendance do
    association :event
    association :friend
  end
end