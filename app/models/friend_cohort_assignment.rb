class FriendCohortAssignment < ApplicationRecord
  belongs_to :friend
  belongs_to :cohort
  validates :friend_id, :cohort_id, presence: true
  validates :friend_id, numericality: { greater_than: 0 }
  validates :friend_id, uniqueness: true
end