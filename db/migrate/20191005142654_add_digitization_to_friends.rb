class AddDigitizationToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :digitized, :boolean, default: false
    add_column :friends, :digitized_at, :datetime
    add_column :friends, :digitized_by, :integer
  end
end
