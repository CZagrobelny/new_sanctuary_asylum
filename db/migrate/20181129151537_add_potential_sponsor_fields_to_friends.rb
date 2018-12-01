class AddPotentialSponsorFieldsToFriends < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :sponsor_name, :string
    add_column :friends, :sponsor_phone_number, :string
    add_column :friends, :sponsor_relationship, :string
  end
end
