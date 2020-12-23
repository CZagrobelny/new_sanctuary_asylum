class AddAgreedToDataEntryPoliciesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :agreed_to_data_entry_policies, :boolean, default: false
  end
end
