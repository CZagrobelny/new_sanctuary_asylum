class Application < ApplicationRecord
  CATEGORIES = %w[appeal asylum asylum_supplementary_docs change_of_venue
                  foia detention habeas_corpus government_issued_document
                  humanitarian_parole identifying_document intake
                  motion_to_reopen nsc_paperwork other remote_review_*attorney_only*
                  report_back sijs work_authorization team_sheet].freeze

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
