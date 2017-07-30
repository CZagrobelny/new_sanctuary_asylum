FactoryGirl.define do
  factory :event do
    association :location
    title {'Title'}
    category {'Category'}
  end
end