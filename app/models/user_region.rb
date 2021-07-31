class UserRegion < ApplicationRecord
  belongs_to :user
  belongs_to :region

  validates :user_id, :region_id, presence: true
end
