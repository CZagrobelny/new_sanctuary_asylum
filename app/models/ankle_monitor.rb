class AnkleMonitor < ApplicationRecord
  belongs_to :friend
  validates :friend_id, presence: true
end
