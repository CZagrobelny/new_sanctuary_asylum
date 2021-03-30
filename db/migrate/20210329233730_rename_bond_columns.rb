class RenameBondColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column(:friends, :bond_amount, :total_bond_amount)
    rename_column(:friends, :bonded_out_by, :obligor)
  end
end
