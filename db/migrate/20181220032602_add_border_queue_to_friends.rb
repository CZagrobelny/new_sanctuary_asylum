class AddBorderQueueToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :border_queue_number, :integer
  end
end
