class AddPledgeSignedToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :pledge_signed, :boolean, default: false
  end
end
