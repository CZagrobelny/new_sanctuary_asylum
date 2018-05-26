class Region < ApplicationRecord
  has_many :communities
  has_many :user_regions
  has_many :users, through: :user_regions
  has_many :lawyers
  has_many :locations
  has_many :judges
  has_many :activities
end
