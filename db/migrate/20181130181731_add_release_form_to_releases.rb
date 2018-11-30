class AddReleaseFormToReleases < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :release_form, :string
  end
end
