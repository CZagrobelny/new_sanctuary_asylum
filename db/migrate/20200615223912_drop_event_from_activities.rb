class DropEventFromActivities < ActiveRecord::Migration[5.2]
  def change
    remove_column :activities, :event
  end
end
