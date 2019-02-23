FactoryBot.define do
  factory :user_region do
    association :region
    association :user
  end
end
