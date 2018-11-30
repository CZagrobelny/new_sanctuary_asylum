class Release < ApplicationRecord
  TYPES = %w{
    limited_scope
  }.freeze

  belongs_to :friend

  mount_uploader :release_form, ReleaseFormUploader

  validates :release_form, presence: true
  validates :category, presence: true, inclusion: { in: TYPES }
end
