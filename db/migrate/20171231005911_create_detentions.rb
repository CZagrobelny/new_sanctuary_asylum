class CreateDetentions < ActiveRecord::Migration[5.0]
  def change
    create_table :detentions do |t|
        t.integer :friend_id, :null => false
        t.date :date_detained
        t.integer :location_id
        t.text :notes
        t.date :date_released
        t.string :case_status
        t.string :other_case_status

        t.timestamps :null => false
    end
  end
end
