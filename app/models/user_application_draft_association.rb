class UserApplicationDraftAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :application_draft
end
