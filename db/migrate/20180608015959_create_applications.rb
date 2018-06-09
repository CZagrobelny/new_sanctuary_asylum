class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.integer :status
      t.datetime :first_submitted_on
      t.datetime :approved_on
      t.references :friend, index: true
      t.string :category

      t.timestamps
    end
  end
end
