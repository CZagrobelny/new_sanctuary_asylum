class Community < ApplicationRecord
  belongs_to :region
  has_many :users
  has_many :friends
  has_many :events
  has_many :sanctuaries

  validates :region_id, presence: true

  def to_param
    slug
  end
end
