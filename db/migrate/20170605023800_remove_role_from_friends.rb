class RemoveRoleFromFriends < ActiveRecord::Migration[5.0]
  def change
  	remove_column :friends, :role
  end
end
