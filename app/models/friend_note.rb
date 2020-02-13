class FriendNote < ApplicationRecord
  belongs_to :friend
  belongs_to :user
  validates :friend, :user, :note, presence: true
end
