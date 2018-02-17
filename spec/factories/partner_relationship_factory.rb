FactoryGirl.define do
  factory :partner_relationship do
    friend_id { create(:friend).id }
    partner_id { create(:friend).id }
  end
end
