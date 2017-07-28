class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.datetime :date
      t.integer :location_id
      t.string :title, default: ""
      t.string :event_catagory

      t.timestamps
    end
  end
end
