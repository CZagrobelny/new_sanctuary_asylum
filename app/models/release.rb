class Release < ApplicationRecord
  belongs_to :friend

  mount_uploader :release_form, ReleaseFormUploader
end
