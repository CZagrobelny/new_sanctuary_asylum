class AddBondsToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :bonded_out_by_nsc, :bool
    add_column :friends, :bond_amount, :integer
    add_column :friends, :date_bonded_out, :datetime
    add_column :friends, :bonded_out_by, :integer
  end
end
