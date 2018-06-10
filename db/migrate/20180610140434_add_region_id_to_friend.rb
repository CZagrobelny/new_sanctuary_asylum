class AddRegionIdToFriend < ActiveRecord::Migration[5.0]
  def change
    add_reference :friends, :region, foreign_key: true
  end
end
