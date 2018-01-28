class AccompanimentReport < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
  validates :notes, :activity_id, presence: true
end