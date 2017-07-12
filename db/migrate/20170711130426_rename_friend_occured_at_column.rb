class RenameFriendOccuredAtColumn < ActiveRecord::Migration[5.0]
  def change
  	rename_column :activities, :occured_at, :occur_at
  end
end
