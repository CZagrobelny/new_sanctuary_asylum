class Location < ApplicationRecord

  belongs_to :region
  has_many :events
  has_many :activities

  validates :name, presence: true

end
