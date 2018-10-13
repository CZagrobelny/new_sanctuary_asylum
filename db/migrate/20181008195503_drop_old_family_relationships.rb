class DropOldFamilyRelationships < ActiveRecord::Migration[5.0]
  def change
    drop_table :parent_child_relationships
    drop_table :partner_relationships
    drop_table :sibling_relationships
    drop_table :spousal_relationships
  end
end
