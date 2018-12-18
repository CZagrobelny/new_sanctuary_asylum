class AddAccompanimentEligibility < ActiveRecord::Migration[5.0]
  def change
    add_column :activity_types, :accompaniment_eligible, :boolean
  end
end
