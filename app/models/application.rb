class Application < ApplicationRecord
  CATEGORIES = %w[asylum sijs work_authorization
                  detention foia change_of_venue
                  other].freeze

  has_many :drafts
  belongs_to :friend

  validates :friend, presence: true
  validates :category, presence: true

  before_save :validate_category_uniquness

  enum status: %i[in_progress
                  in_review
                  changes_requested
                  approved
                  closed]

  private

  def validate_category_uniquness
    other_applications_present? ? check_category : true
  end

  def other_applications_present?
    friend.reload.applications.present?
  end

  def friend_categories
    friend.applications.map(&:category)
  end

  def check_category
    return unless friend_categories.include?(category)

    errors.add(:category, 'category must be unique to friend')
    throw :abort
  end
end
