class Region < ApplicationRecord
  has_many :communities
  has_many :friends
  has_many :user_regions
  has_many :users, through: :user_regions
  has_many :lawyers
  has_many :locations
  has_many :judges
  has_many :activities

  validates :name, presence: true
  validates_uniqueness_of :name
end
