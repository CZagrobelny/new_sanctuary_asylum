FactoryGirl.define do
  factory :accompaniment_report_authorship do
  	association :accompaniment_report
  	association :user
  end
end