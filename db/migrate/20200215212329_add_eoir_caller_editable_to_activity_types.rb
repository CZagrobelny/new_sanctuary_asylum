class AddEoirCallerEditableToActivityTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :activity_types, :eoir_caller_editable, :boolean, default: false
  end
end
