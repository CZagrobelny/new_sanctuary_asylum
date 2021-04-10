class AddBondStatusToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :bond_status, :string
  end
end
