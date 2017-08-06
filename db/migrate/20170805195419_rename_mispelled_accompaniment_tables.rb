class RenameMispelledAccompanimentTables < ActiveRecord::Migration[5.0]
  def change
  	rename_table :accompaniements, :accompaniments
  end
end
