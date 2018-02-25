class SpousalRelationship < ApplicationRecord
  belongs_to :friend
  belongs_to :spouse, class_name: 'Friend'

  validates :friend_id, :spouse_id, presence: true 
end