class AddNeighborhoodIdToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :neighborhood_id, :integer
  end
end
