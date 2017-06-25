class CreateFamily < ActiveRecord::Migration[5.0]
  def change
    create_table :family_members do |t|
    	t.integer :friend_id, null: false
    	t.integer :relation_id, null: false
    	t.integer :relationship, null: false
    	t.integer :parent_id
    	t.integer :child_id
        t.index :friend_id
        t.index :relation_id

        t.timestamps :null => false
    end
  end
end
