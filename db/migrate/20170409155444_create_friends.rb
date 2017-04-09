class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.integer :role, :null => false, :default => 0
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :phone
      t.string :email
      t.string :a_number
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps :null => false 
    end
  end
end
