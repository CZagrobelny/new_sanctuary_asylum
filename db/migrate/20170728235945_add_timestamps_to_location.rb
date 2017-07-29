class AddTimestampsToLocation < ActiveRecord::Migration[5.0]
  def change
  	Location.destroy_all
  	add_timestamps(:locations)
  end
end
