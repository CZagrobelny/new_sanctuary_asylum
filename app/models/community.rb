class Community < ApplicationRecord
  belongs_to :region
  has_many :users
  has_many :friends
  has_many :events
  has_many :sanctuaries

  validates :region_id, :name, :slug, presence: true
  validates_uniqueness_of :slug
  validate :slug_format

  def to_param
    slug
  end

  private

  def slug_format
    return if /^[a-z-]+$/.match?(slug)
    errors.add(:slug,
               'must be all lowercase letters with no spaces. ' \
               'Dashes may be used to separate words, like "a-' \
               'slug-with-dashes"')
  end
end
