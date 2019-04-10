class AddIntakeDatesToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :intake_date, :datetime
    add_column :friends, :must_be_seen_by, :datetime
  end
end
