class Location < ApplicationRecord
  belongs_to :region
  has_many :events
  has_many :activities

  validates :name, :region_id, presence: true
end
