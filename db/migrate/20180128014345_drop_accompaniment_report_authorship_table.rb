class DropAccompanimentReportAuthorshipTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :accompaniment_report_authorships
  end
end
