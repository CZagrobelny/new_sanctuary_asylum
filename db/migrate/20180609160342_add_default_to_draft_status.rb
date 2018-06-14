class AddDefaultToDraftStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :drafts, :status, :integer, default: 0
  end
end
