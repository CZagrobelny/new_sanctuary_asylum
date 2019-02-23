FactoryBot.define do
  factory :activity_type do
    name 'family_court'
    accompaniment_eligible true
  end

  trait :with_cap_3 do
    cap 3
  end
end
