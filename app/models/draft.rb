class Draft < ApplicationRecord
  belongs_to :application
  belongs_to :friend #TODO migrate this to the Application table and depricate 
  has_many :user_draft_associations, dependent: :destroy
  has_many :users, through: :user_draft_associations
  mount_uploader :pdf_draft, PdfDraftUploader
  validates :pdf_draft, presence: true
  validates :category, presence: true

  enum status: [ :in_progress, 
                 :in_review,
                 :changes_requested,
                 :approved,
                 :closed ]
end
