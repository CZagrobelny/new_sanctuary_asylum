class AddCommunityIdToSanctuaries < ActiveRecord::Migration[5.0]
  def change
    add_reference :sanctuaries, :community, foreign_key: true
  end
end
