class AddDetentionAttributesToFriend < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :visited_the_clinic, :boolean
    add_column :friends, :criminal_conviction, :boolean
    add_column :friends, :criminal_conviction_notes, :text
    add_column :friends, :final_order_of_removal, :boolean
    add_column :friends, :has_a_lawyer_for_detention, :boolean
    add_column :friends, :detention_advocate_contact_name, :string
    add_column :friends, :detention_advocate_contact_phone, :string
    add_column :friends, :detention_advocate_contact_notes, :text
  end
end
