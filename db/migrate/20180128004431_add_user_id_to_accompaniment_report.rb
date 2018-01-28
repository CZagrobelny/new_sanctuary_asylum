class AddUserIdToAccompanimentReport < ActiveRecord::Migration[5.0]
  def change
    add_column :accompaniment_reports, :user_id, :integer
  end
end
