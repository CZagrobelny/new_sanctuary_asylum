class AddOutcomeToAccompanimentReport < ActiveRecord::Migration[5.0]
  def change
    add_column :accompaniment_reports, :outcome_of_hearing, :text
  end
end
