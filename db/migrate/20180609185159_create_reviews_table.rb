class CreateReviewsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.text :notes
      t.references :draft
      t.references :user

      t.timestamps
    end
  end
end
