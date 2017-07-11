class CreateUserAsylumApplicationDraftAssociation < ActiveRecord::Migration[5.0]
  def change
    create_table :user_asylum_application_draft_associations do |t|
      t.integer :user_id, :null => false
      t.integer :asylum_application_draft_id, :null => false

      t.timestamps :null => false
    end
  end
end
