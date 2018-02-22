class UserSijsApplicationDraftAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :sijs_application_draft
end