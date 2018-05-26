class AddRegionIdToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :region, foreign_key: true
  end
end
