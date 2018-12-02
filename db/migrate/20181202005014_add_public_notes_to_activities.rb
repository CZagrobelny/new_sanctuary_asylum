class AddPublicNotesToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :public_notes, :text
  end
end
