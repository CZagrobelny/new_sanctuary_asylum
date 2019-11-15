class ControlDateToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :control_date, :datetime
  end
end
