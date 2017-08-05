class AddColsToLaywers < ActiveRecord::Migration[5.0]
  def change
  	add_column :lawyers, :email, :string
  	add_column :lawyers, :organization, :string
  	add_column :lawyers, :phone_number, :string
  end
end
