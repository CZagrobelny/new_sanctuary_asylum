class UserDraftAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :draft
end
