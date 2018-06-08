class RenameApplicationDraftsToDrafts < ActiveRecord::Migration[5.0]
  def change
    rename_table :application_drafts, :drafts
  end
end
