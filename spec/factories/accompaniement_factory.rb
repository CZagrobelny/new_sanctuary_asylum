FactoryGirl.define do
  factory :accompaniement do
    association :activity
    association :user
  end
end