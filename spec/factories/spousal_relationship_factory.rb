FactoryGirl.define do
  factory :parent_child_relationship do
    parent_id { create(:friend).id }
    child_id { create(:friend).id }
  end
end