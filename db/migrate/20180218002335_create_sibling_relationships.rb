class CreateSiblingRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :sibling_relationships do |t|
      t.integer :friend_id, null: false
      t.integer :sibling_id, null: false

      t.timestamps
    end
  end
end
