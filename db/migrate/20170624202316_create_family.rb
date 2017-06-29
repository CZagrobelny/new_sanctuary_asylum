class CreateFamily < ActiveRecord::Migration[5.0]
  def change
    create_table :parent_child_relationships do |t|
        t.integer :parent_id, null: false
        t.integer :child_id, null: false

        t.timestamps :null => false
    end

    create_table :spousal_relationships do |t|
        t.integer :friend_id, null: false
        t.integer :spouse_id, null: false

        t.timestamps :null => false
    end
  end
end
