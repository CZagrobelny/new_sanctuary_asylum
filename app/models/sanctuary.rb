class Sanctuary < ApplicationRecord
  belongs_to :community
  validates :name, :leader_name, :community_id, presence: true
end
