class ApplicationDraft < ApplicationRecord
  belongs_to :friend
  has_many :user_application_draft_associations, dependent: :destroy
  has_many :users, through: :user_application_draft_associations
  mount_uploader :pdf_draft, PdfDraftUploader
  validates :pdf_draft, presence: true
  validates :category, presence: true
  CATEGORIES = %w[asylum sijs work_authorization detention foia change_of_venue other].freeze
end
