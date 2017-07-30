class RenameEventCategory < ActiveRecord::Migration[5.0]
  def change
  	rename_column :events, :event_catagory, :category
  end
end
