class AddFriendToAccompanimentReports < ActiveRecord::Migration[5.2]
  def up
    add_reference :accompaniment_reports, :friend, index: false

    execute <<~SQL
    UPDATE accompaniment_reports
    SET friend_id = (SELECT friend_id FROM activities WHERE id = accompaniment_reports.activity_id)
    SQL
  end

  def down
    remove_reference :accompaniment_reports, :friend
  end
end
