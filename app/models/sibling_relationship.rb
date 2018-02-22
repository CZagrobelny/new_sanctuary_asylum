class SiblingRelationship < ApplicationRecord
  belongs_to :friend
  belongs_to :sibling, class_name: 'Friend'

  validates :friend_id, :sibling_id, presence: true
end
