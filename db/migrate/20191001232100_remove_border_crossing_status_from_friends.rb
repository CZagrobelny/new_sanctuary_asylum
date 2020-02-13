class RemoveBorderCrossingStatusFromFriends < ActiveRecord::Migration[5.2]
  def change
    remove_column :friends, :border_crossing_status
  end
end
