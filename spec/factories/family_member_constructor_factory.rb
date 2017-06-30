FactoryGirl.define do
  factory :family_member_constructor do
    relationship { 'spouse' }
    friend_id { create(:friend).id }
    relation_id { create(:friend).id }
  end
end