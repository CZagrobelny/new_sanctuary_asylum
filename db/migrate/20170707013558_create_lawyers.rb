class CreateLawyers < ActiveRecord::Migration[5.0]
  def change
    create_table :lawyers do |t|
    	t.string :first_name, :null => false
      	t.string :last_name, :null => false

      	t.timestamps :null => false 
    end
  end
end
