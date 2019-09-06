class CreateVolunteerLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :volunteer_languages do |t|
      t.integer "user_id", null: false, index: true
      t.integer "language_id", null: false, index: true
      t.timestamps
    end
  end
end
