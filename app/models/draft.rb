class Draft < ApplicationRecord
  belongs_to :application
  belongs_to :friend #TODO migrate this to the Application table and depricate 
  has_many :user_application_draft_associations, dependent: :destroy
  has_many :users, through: :user_application_draft_associations
  mount_uploader :pdf_draft, PdfDraftUploader
  validates :pdf_draft, presence: true
  validates :category, presence: true
  CATEGORIES = %w[asylum sijs work_authorization detention foia change_of_venue other].freeze
end
