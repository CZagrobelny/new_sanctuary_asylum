class AddUserIdToReleases < ActiveRecord::Migration[5.0]
  def change
    add_reference :releases, :user, foreign_key: true
  end
end
