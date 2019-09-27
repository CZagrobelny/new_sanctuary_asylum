class AddCombinedActivities < ActiveRecord::Migration[5.2]
  def change
    add_reference(:activities, :combined_activity_parent, foreign_key: {to_table: :activities})
  end
end
