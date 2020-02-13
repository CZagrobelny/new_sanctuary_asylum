class OccurAtTbdToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :occur_at_tbd, :boolean
  end
end
