FactoryBot.define do
  factory :accompaniment_report do
  	association :activity
    association :user
  	notes 'test notes'
  end
end