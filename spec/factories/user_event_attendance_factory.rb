FactoryGirl.define do
  factory :user_event_attendance do
    association :event
    association :user
  end
end