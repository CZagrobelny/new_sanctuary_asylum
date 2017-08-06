FactoryGirl.define do
  factory :accompaniment_report do
  	association :activity
  	notes 'test notes'
  end
end