class CreateUserSijsApplicationDraftAssociation < ActiveRecord::Migration[5.0]
  def change
    create_table :user_sijs_application_draft_associations do |t|
      t.integer :user_id, :null => false
      t.integer :sijs_application_draft_id, :null => false

      t.timestamps :null => false
    end
  end
end
