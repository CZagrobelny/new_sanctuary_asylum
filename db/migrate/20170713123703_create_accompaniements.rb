class CreateAccompaniements < ActiveRecord::Migration[5.0]
  def change
    create_table :accompaniements do |t|
    	t.integer :activity_id
    	t.integer :user_id
    	t.text :availability_notes
    end
  end
end
