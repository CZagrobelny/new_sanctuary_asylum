class FamilyRelationship < ApplicationRecord
  belongs_to :friend
  belongs_to :relation, class_name: 'Friend'
  has_one :reciprocal_relationship, class_name: 'FamilyRelationship', foreign_key: 'reciprocal_relationship_id'

  validates_presence_of :friend_id, :relation_id, :relationship_type
  validates_uniqueness_of :relation_id, scope: :friend_id
  validates_presence_of :reciprocal_relationship_id, on: :update
end
