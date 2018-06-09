class AddCommunityIdToFriends < ActiveRecord::Migration[5.0]
  def change
    add_reference :friends, :community, foreign_key: true
  end
end
