class ChangeUserApplicationDraftAssociationTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :user_application_draft_associations, :user_draft_associations
    rename_column :user_draft_associations, :application_draft_id, :draft_id
  end
end
