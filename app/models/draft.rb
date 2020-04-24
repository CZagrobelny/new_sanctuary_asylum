class Draft < ApplicationRecord
  belongs_to :application
  belongs_to :friend
  has_many :user_draft_associations, dependent: :destroy
  has_many :users, through: :user_draft_associations
  has_many :reviews
  has_many :remote_review_actions, dependent: :destroy
  mount_uploader :pdf_draft, PdfDraftUploader
  validates :pdf_draft, presence: true
  validates :application_id, presence: true

  enum status: %i[in_progress
                  review_requested
                  review_added
                  approved
                  closed]

  NO_STATUS_MESSAGE = 'No status set'.freeze

  def status_string
    status ? status.humanize : NO_STATUS_MESSAGE
  end
end
