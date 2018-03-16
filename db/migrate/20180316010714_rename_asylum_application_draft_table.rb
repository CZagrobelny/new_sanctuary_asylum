class RenameAsylumApplicationDraftTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :asylum_application_drafts, :application_drafts
  end
end
