class AddFamuDocketToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :famu_docket, :boolean, default: false
  end
end
