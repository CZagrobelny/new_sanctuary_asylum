class CreateAccompanimentReportAuthorships < ActiveRecord::Migration[5.0]
  def change
    create_table :accompaniment_report_authorships do |t|
    	t.integer :user_id, :null => false
    	t.integer :accompaniment_report_id, :null => false
    	t.timestamps
    end
  end
end
