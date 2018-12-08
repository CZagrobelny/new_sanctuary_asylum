class AddStateToFriend < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :state, :string
  end
end
