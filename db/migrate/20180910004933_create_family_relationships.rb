class CreateFamilyRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :family_relationships do |t|
      t.belongs_to :friend, index: true
      t.belongs_to :relation, index: true
      t.string :relationship_type
      t.integer :reciprocal_relationship_id
      t.index :reciprocal_relationship_id, unique: true
      t.timestamps
    end
  end
end
