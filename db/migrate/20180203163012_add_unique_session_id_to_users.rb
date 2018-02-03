class AddUniqueSessionIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unique_session_id, :string, :limit => 20
  end
end
