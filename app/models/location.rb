class Location < ApplicationRecord
  belongs_to :region
  has_many :events, dependent: :restrict_with_error
  has_many :activities, dependent: :restrict_with_error

  validates :name, :region_id, presence: true
end
