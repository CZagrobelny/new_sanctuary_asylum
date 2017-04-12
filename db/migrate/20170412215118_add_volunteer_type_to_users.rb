class AddVolunteerTypeToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :volunteer_type, :integer
  end
end
