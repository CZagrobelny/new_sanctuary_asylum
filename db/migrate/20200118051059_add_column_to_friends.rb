class AddColumnToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :no_record_in_eoir, :boolean, default: false
    add_column :friends, :order_of_supervision, :boolean, default: false
  end
end
