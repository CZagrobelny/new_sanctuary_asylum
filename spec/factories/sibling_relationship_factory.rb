FactoryGirl.define do
  factory :sibling_relationship do
    friend_id { create(:friend).id }
    sibling_id { create(:friend).id }
  end
end
