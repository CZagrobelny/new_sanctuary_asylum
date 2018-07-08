class Application < ApplicationRecord
  CATEGORIES = %w[asylum sijs work_authorization
                  detention foia change_of_venue
                  other].freeze

  has_many :drafts
  belongs_to :friend

  validates :friend, presence: true
  validates :category, presence: true
  validates_uniqueness_of :category, scope: :friend_id

  enum status: %i[in_progress
                  in_review
                  changes_requested
                  approved
                  closed]
end
