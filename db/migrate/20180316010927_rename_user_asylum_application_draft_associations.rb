class RenameUserAsylumApplicationDraftAssociations < ActiveRecord::Migration[5.0]
  def change
    rename_table :user_asylum_application_draft_associations, :user_application_draft_associations
  end
end
