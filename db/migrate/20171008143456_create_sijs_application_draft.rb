class CreateSijsApplicationDraft < ActiveRecord::Migration[5.0]
  def change
    create_table :sijs_application_drafts do |t|
        t.text :notes
        t.integer :friend_id, :null => false
        t.timestamps :null => false
        t.string :pdf_draft, :null => false
    end
  end
end
