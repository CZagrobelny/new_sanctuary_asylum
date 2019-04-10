class AddIntakeNotesToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :intake_notes, :text
  end
end
