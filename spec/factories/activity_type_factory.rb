FactoryGirl.define do
  factory :activity_type do
    name 'family_court'
    cap 3
    accompaniment_eligible true
  end

  trait :master_calendar_hearing do
    name 'master_calendar_hearing'
    id name: "master_calendar_hearing"
    accompaniment_eligible true
  end
end
