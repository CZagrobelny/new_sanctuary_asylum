FactoryGirl.define do
  factory :application do
    category "asylum"
    association :friend, factory: :friend
  end
end
