class AddSignedGuidelinesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :signed_guidelines, :boolean
  end
end
