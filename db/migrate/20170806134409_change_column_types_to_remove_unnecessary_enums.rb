class ChangeColumnTypesToRemoveUnnecessaryEnums < ActiveRecord::Migration[5.0]
  def change
  	change_column :friends, :status, :string
  	change_column :friends, :asylum_status, :string
  	change_column :friends, :work_authorization_status, :string
  	change_column :friends, :sijs_status, :string
  	change_column :activities, :event, :string
  end
end
