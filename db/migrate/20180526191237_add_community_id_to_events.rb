class AddCommunityIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :community, foreign_key: true
  end
end
