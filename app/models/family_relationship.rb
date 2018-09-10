class FamilyRelationship < ApplicationRecord
  belongs_to :friend
  belongs_to :relation, class_name: 'Friend'
  has_one :reciprocal_relationship, class_name: 'FamilyRelationship', foreign_key: 'reciprocal_relationship_id'

  validates_presence_of :friend_id, :relation_id, :relationship_type
  validates_uniqueness_of :relation_id, scope: :friend_id
  validates_presence_of :reciprocal_relationship_id, on: :update

  after_create :create_reciprocal_relationship
  after_destroy :destroy_reciprocal_relationship

  private

  def create_reciprocal_relationship
    return if FamilyRelationship.where(friend_id: relation_id, relation_id: friend_id).present?

    reciprocal_relationship = FamilyRelationship.create!(friend_id: relation_id,
      relation_id: friend_id,
      relationship_type: reciprocal_relationship_type,
      reciprocal_relationship_id: id)

    self.update_attributes!(reciprocal_relationship_id: reciprocal_relationship.id)
  end

  def destroy_reciprocal_relationship
    reciprocal_relationship = FamilyRelationship.where(friend_id: relation_id, relation_id: friend_id).first
    return unless reciprocal_relationship.present?
    reciprocal_relationship.destroy!
  end

  def reciprocal_relationship_type
    case relationship_type
    when 'child'
      'parent'
    when 'parent'
      'child'
    else
      relationship_type
    end
  end
end
