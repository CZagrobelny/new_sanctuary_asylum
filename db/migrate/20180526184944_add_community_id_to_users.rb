class AddCommunityIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :community, foreign_key: true
  end
end
