class AddZipcodeToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :string, :zip_code
  end
end
