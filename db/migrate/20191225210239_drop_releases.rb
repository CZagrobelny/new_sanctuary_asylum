class DropReleases < ActiveRecord::Migration[5.2]
  def change
    drop_table :releases
  end
end
