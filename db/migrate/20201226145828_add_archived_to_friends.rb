class AddArchivedToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :archived, :boolean, default: false
  end
end
