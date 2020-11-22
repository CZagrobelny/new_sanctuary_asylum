class Application < ApplicationRecord
  CATEGORIES = %w[appeal asylum asylum_supplementary_docs change_of_venue
                  detention foia government_issued_document habeas_corpus
                  humanitarian_parole identifying_document individual_hearing_material
                  intake motion_to_reopen nsc_paperwork other remote_review_*attorney_only*
                  report_back sijs work_authorization team_sheet].freeze

  has_many :drafts, dependent: :restrict_with_error
  has_many :remote_review_actions, dependent: :destroy
  belongs_to :friend

  validates :friend, presence: true
  validates :category, presence: true
  validates_uniqueness_of :category, scope: :friend_id

  enum status: %i[in_progress
                  review_requested
                  review_added
                  approved
                  closed]
end
