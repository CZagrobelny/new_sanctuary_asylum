class CreateJoinTableUsersFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :user_friend_associations do |t|
      t.integer :user_id, :null => false
      t.integer :friend_id, :null => false
      t.index :user_id
      t.index :friend_id

      t.timestamps :null => false
    end
  end
end
