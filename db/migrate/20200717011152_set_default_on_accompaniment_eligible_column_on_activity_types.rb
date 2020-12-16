class SetDefaultOnAccompanimentEligibleColumnOnActivityTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :activity_types, :accompaniment_eligible, :boolean, default: false
  end
end
