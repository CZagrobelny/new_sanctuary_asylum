class Region < ApplicationRecord
  has_many :communities
  has_many :friends
  has_many :user_regions
  has_many :users, through: :user_regions
  has_many :lawyers
  has_many :locations
  has_many :judges
  has_many :activities
  has_many :remote_review_actions

  validates :name, presence: true
  validates_uniqueness_of :name

  def regional_admins
    users.where(role: 'admin')
  end

  # A gross hack we need for features that should only be turned on for the BORDER region
  def border?
    name == 'border'
  end
end
