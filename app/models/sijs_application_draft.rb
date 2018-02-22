class SijsApplicationDraft < ApplicationRecord
  belongs_to :friend
  has_many :user_sijs_application_draft_associations, dependent: :destroy
  has_many :users, through: :user_sijs_application_draft_associations
  mount_uploader :pdf_draft, PdfDraftUploader
  validates :pdf_draft, presence: true
end