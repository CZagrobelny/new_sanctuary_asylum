class AddBondNotesToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :bond_notes, :text
  end
end
