class AddDateAppliedToAnkleMonitors < ActiveRecord::Migration[5.2]
  def change
    add_column :ankle_monitors, :date_applied, :datetime
  end
end
