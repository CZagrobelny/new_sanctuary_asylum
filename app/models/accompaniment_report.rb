class AccompanimentReport < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  validates :notes, :activity_id, presence: true
end