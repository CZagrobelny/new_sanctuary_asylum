class AddRegionIdToLawyers < ActiveRecord::Migration[5.0]
  def change
    add_reference :lawyers, :region, foreign_key: true
  end
end
