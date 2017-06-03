class RemoveAddressFromFriendsTable < ActiveRecord::Migration[5.0]
  def change
  	remove_column :friends, :address
  	remove_column :friends, :address2
  	remove_column :friends, :city
  	remove_column :friends, :state
  	remove_column :friends, :zip
  end
end
