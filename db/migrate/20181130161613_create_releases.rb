class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.belongs_to :friend, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
