class FamilyRelationship < ApplicationRecord
  belongs_to :friend
  belongs_to :relation, class_name: 'Friend'

  validates_presence_of :friend_id, :relation_id, :relationship_type
  validates_uniqueness_of :relation_id,
    scope: :friend_id,
    message: 'is already listed as a family member for this friend'

  after_create :create_reciprocal_relationship
  after_destroy :destroy_reciprocal_relationship

  TYPES = %w(parent child spouse partner).map{ |type| [type.titlecase, type] }

  private

  def create_reciprocal_relationship
    unless reciprocal_relationship.present?
      FamilyRelationship.create!(friend_id: relation_id,
        relation_id: friend_id,
        relationship_type: reciprocal_relationship_type)
    end
  end

  def destroy_reciprocal_relationship
    return unless reciprocal_relationship
    reciprocal_relationship.destroy!
  end

  def reciprocal_relationship
    FamilyRelationship.find_by(friend_id: relation_id, relation_id: friend_id)
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
