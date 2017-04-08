class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :role, :null => false, :default => 0
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :phone

      t.timestamps :null => false    
    end
  end
end
