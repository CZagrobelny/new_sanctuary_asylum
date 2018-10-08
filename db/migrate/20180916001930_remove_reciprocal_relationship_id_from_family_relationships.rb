class RemoveReciprocalRelationshipIdFromFamilyRelationships < ActiveRecord::Migration[5.0]
  def change
    remove_index :family_relationships, :reciprocal_relationship_id
    remove_column :family_relationships, :reciprocal_relationship_id
  end
end
