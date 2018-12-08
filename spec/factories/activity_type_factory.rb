FactoryGirl.define do
  factory :activity_type do
    name 'family_court'
    cap 3
  end

  trait :master_calendar_hearing do
    name 'master_calendar_hearing'
    id name: "master_calendar_hearing"
  end
end
