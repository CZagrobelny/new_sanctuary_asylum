class RenameAsylumApplicationDraftIdInAssociation < ActiveRecord::Migration[5.0]
  def change
    rename_column :user_application_draft_associations, :asylum_application_draft_id, :application_draft_id
  end
end
