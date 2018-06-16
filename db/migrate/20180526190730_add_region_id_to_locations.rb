class AddRegionIdToLocations < ActiveRecord::Migration[5.0]
  def change
    add_reference :locations, :region, foreign_key: true
  end
end
