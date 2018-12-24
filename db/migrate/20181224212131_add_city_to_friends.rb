class AddCityToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :city, :string
  end
end
