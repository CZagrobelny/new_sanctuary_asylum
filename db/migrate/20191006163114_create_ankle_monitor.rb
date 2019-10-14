class CreateAnkleMonitor < ActiveRecord::Migration[5.2]
  def change
    create_table :ankle_monitors do |t|
      t.datetime :date_removed
      t.boolean :bi_smart_link
      t.text :notes
      t.references :friend
      t.timestamps
    end
  end
end
