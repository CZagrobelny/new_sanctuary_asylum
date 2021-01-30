class AddDeactivatedToAccessTimeSlots < ActiveRecord::Migration[6.0]
  def change
    add_column :access_time_slots, :deactivated, :boolean, default: false
  end
end
