class Location < ActiveRecord::Base

  has_many :events
  has_many :activities

  validates :name, presence: true
  
end
