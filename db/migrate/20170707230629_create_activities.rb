class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :event
      t.integer :location_id
      t.integer :friend_id
      t.integer :judge_id
      t.datetime :occured_at
      t.text :notes

      t.timestamps
    end
  end
end
