class AddRegionIdToJudges < ActiveRecord::Migration[5.0]
  def change
    add_reference :judges, :region, foreign_key: true
  end
end
