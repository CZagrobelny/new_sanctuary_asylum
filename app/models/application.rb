class Application < ApplicationRecord
  CATEGORIES = %w[intake humanitarian_parole identifying_document
                  asylum sijs work_authorization
                  detention foia change_of_venue
                  habeas_corpus report_back other remote_review_*attorney_only*].freeze

  has_many :drafts, dependent: :restrict_with_error
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
