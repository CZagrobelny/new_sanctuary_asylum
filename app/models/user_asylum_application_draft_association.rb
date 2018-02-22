class UserAsylumApplicationDraftAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :asylum_application_draft
end