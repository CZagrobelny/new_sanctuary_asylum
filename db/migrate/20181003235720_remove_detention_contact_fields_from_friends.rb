class RemoveDetentionContactFieldsFromFriends < ActiveRecord::Migration[5.0]
  def change
    remove_column :friends, :visited_the_clinic
    remove_column :friends, :detention_advocate_contact_name
    remove_column :friends, :detention_advocate_contact_phone
    remove_column :friends, :detention_advocate_contact_notes
  end
end
