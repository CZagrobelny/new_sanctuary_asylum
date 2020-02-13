class AddReleaseFormsSignedToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :releases_signed, :boolean
  end
end
