class RemoveBorderQueueNumberFromFriends < ActiveRecord::Migration[5.2]
  def change
    remove_column :friends, :border_queue_number
  end
end
