class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend
end