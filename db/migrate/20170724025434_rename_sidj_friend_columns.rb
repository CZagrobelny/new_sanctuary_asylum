class RenameSidjFriendColumns < ActiveRecord::Migration[5.0]
  def change
  	rename_column :friends, :sidj_status, :sijs_status
    rename_column :friends, :date_sidj_submitted, :date_sijs_submitted
    rename_column :friends, :sidj_notes, :sijs_notes
  end
end
