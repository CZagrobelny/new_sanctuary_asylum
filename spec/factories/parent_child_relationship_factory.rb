FactoryGirl.define do
  factory :spousal_relationship do
    friend_id { create(:friend).id }
    spouse_id { create(:friend).id }
  end
end