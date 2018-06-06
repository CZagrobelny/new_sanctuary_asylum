FactoryGirl.define do
  factory :region do
    name { FFaker::Address.us_state.downcase.gsub(/[^a-z]/i, '') }
  end
end
