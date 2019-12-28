class ChangeFriendNoteColumnsToNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_null :friend_notes, :friend_id, false
    change_column_null :friend_notes, :user_id, false
    change_column_null :friend_notes, :note, false
  end
end
