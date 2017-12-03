class AddZipcodeToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :zip_code, :string
  end
end
