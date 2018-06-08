class Application < ApplicationRecord
  CATEGORIES = ['asylum', 'sijs', 'work_authorization',
                'detention', 'foia', 'change_of_venue',
                'other']

  has_many :drafts
  belongs_to :friend

  validates :friend, presence: true
  validates :category, presence: true

  before_save :validate_category_uniquness

  enum status: [ :in_progress, 
                 :in_review,
                 :changes_requested,
                 :approved,
                 :closed ]

  private

  def validate_category_uniquness
    other_applications_present? ? check_category : true
  end

  def other_applications_present?
    friend.reload.applications.present?
  end

  def friend_categories
    friend.applications.map { |application| application.category }
  end

  def check_category
    if friend_categories.include?(category)
      self.errors.add(:category, "category must be unique to friend")
      throw :abort
    end
  end
end
