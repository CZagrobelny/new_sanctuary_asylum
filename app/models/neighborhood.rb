class Neighborhood < ApplicationRecord
  has_many :friends
  validates :name
end
