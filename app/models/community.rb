class Community < ApplicationRecord
  belongs_to :region
  has_many :users
  has_many :friends
  has_many :events
  has_many :cohorts
  has_many :sanctuaries
  has_many :access_time_slots
  has_many :remote_review_actions

  validates :region_id, :name, :slug, presence: true
  validates_uniqueness_of :slug
  validate :slug_format

  def to_param
    slug
  end

  private

  def slug_format
    return if /^[a-z-]+$/ =~ slug

    errors.add(:slug,
               'must be all lowercase letters with no spaces. ' \
               'Dashes may be used to separate words, like "a-' \
               'slug-with-dashes"')
  end
end
