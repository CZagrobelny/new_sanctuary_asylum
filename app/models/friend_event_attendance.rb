class FriendEventAttendance < ActiveRecord::Base
  belongs_to :friend
  belongs_to :event
  validates :friend_id, :event_id, presence: true
end