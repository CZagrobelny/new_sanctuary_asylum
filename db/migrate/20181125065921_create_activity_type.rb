class CreateActivityType < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_types do |t|
      t.string :name, unique: true
      t.integer :cap
      t.timestamps
    end

    add_column :activities, :activity_type_id
  end
end
