class AddConfirmedToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :confirmed, :boolean
  end
end
