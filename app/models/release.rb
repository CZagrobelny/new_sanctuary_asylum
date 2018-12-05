class Release < ApplicationRecord
  TYPES = %w{
    limited_scope
  }.freeze

  belongs_to :friend
  belongs_to :user # Validation below that this user is a lawyer

  mount_uploader :release_form, ReleaseFormUploader

  validates :release_form, presence: true
  validates :category, presence: true, inclusion: { in: TYPES }
end
