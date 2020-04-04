class AccompanimentReport < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  belongs_to :friend
  validates :notes, :activity_id, presence: true

  accepts_nested_attributes_for :friend, update_only: true
end
