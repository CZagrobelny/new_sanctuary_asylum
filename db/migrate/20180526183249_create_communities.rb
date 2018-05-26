class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.belongs_to :region, foreign_key: true
      t.string :name
      t.string :slug
      t.boolean :primary
      t.boolean :accompaniment_program_active
      t.boolean :locations_editable
      t.boolean :reports_active
      t.boolean :sanctuaries_active
      t.boolean :events_active
      t.boolean :judges_editable
    end
  end
end
