class AddTimestampsToAccompaniment < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:accompaniments, null: true)
  end
end
