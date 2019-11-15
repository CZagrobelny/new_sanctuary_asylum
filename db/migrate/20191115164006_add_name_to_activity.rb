class AddNameToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :last_edited_by, :integer
  end
end
