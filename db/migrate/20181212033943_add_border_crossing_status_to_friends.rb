class AddBorderCrossingStatusToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :border_crossing_status, :string
  end
end
