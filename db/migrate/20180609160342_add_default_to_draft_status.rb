class AddDefaultToDraftStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :drafts, :status, :integer, default: :in_progress
  end
end
