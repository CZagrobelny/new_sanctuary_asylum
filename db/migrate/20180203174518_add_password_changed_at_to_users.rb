class AddPasswordChangedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_changed_at, :datetime
    add_index :users, :password_changed_at
  end
end
