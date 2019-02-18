class AddJailIdToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :jail_id, :string
  end
end
