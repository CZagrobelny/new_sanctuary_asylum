class Neighborhood < ActiveRecord::Base
  has_many :friends
  validates :name, presence: true
end
