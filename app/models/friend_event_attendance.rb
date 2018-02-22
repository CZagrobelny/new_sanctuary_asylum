class FriendEventAttendance < ActiveRecord::Base
  belongs_to :friend
  belongs_to :event
  validates :friend_id, :event_id, presence: true
  validates :friend_id, numericality: { greater_than: 0 }
  validates :friend_id, uniqueness: { scope: :event_id }
end
