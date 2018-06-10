class RemoveNonPrimaryColumnsOnCommunities < ActiveRecord::Migration[5.0]
  def change
    remove_column :communities, :accompaniment_program_active
    remove_column :communities, :locations_editable
    remove_column :communities, :reports_active
    remove_column :communities, :sanctuaries_active
    remove_column :communities, :events_active
    remove_column :communities, :judges_editable
  end
end
