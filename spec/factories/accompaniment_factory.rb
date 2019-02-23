FactoryBot.define do
  factory :accompaniment do
    association :activity
    association :user
  end
end