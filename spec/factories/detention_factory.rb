FactoryBot.define do
  factory :detention do
    association :friend
    association :location
    case_status { 'immigration_court' }
  end
end