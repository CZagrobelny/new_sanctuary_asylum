class Sanctuary < ApplicationRecord
  belongs_to :community
  validates :name, :leader_name, presence: true
end
