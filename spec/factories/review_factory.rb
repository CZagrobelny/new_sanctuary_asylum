FactoryGirl.define do
  factory :review do
    association :draft
    association :user
    notes 'A new review!'
  end
end
