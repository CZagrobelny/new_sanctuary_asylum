class UserEventAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :user_id, :event_id, presence: true
  validates :user_id, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :event_id }
end
