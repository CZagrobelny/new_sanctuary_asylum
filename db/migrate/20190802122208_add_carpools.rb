class AddCarpools < ActiveRecord::Migration[5.2]
  def change
    create_table :carpools do |t|
      t.timestamps
    end
    create_table :carpool_activities do |t|
      t.integer :carpool_id
      t.integer :activity_id

      t.timestamps
    end
    change_table :accompaniments do |t|
      t.add_column :carpool_id
    end
  end
end
