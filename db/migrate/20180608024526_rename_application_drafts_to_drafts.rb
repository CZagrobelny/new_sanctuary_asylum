class RenameApplicationDraftsToDrafts < ActiveRecord::Migration[5.0]
  def change
    rename_table :application_drafts, :drafts
    add_reference :drafts, :application
    add_column :drafts, :status, :integer
  end
end
