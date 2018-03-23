class AddCategoryToApplicationDraft < ActiveRecord::Migration[5.0]
  def change
    add_column :application_drafts, :category, :string
  end
end
