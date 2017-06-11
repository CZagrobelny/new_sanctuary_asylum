class AddAsylumNotesToFriends < ActiveRecord::Migration[5.0]
  def change
  	add_column :friends, :asylum_notes, :text
  end
end
