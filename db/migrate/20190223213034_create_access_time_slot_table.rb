class CreateAccessTimeSlotTable < ActiveRecord::Migration[5.2]
  def change
    create_table :access_time_slots do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :use, null: false
      t.integer :grantor_id, null: false
      t.integer :grantee_id, null: false
      t.timestamps
    end
  end
end
