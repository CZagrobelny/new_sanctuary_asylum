class CreateAccompanimentReports < ActiveRecord::Migration[5.0]
  def change
    create_table :accompaniment_reports do |t|
    	t.integer :activity_id, :null => false
    	t.text :notes
    	t.timestamps :null => false
    end
  end
end
