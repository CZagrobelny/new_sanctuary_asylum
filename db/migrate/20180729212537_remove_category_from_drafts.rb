class RemoveCategoryFromDrafts < ActiveRecord::Migration[5.0]
  def change
    remove_column :drafts, :category
  end
end
