class CreateAsylumApplicationDraft < ActiveRecord::Migration[5.0]
  def change
    create_table :asylum_application_drafts do |t|
    	t.text :notes
    	t.integer :friend_id, :null => false
    	t.timestamps :null => false
    end
  end
end
