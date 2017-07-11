FactoryGirl.define do
  factory :user_friend_association do
    association :friend
    association :user
  end
end