class CreateCohorts < ActiveRecord::Migration[5.2]
  def change
    create_table :cohorts do |t|
      t.datetime :start_date, null: false
      t.string :color, null: false
      t.references :community, index: true, null: false
      t.timestamps
    end
  end
end
