class AddFriendsNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_notes do |t|
      t.references :friend, index:true, foreign_key: true
      t.references :user, index:true, foreign_key: true
      t.text :note
      t.timestamps
    end
  end
end
