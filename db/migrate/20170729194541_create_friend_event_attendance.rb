class CreateFriendEventAttendance < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_event_attendances do |t|
      t.integer :friend_id, :null => false
      t.integer :event_id, :null => false

      t.timestamps :null => false
    end
  end
end
