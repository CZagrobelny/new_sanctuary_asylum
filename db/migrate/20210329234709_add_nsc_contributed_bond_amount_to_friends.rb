class AddNscContributedBondAmountToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :nsc_contributed_bond_amount, :integer
  end
end
