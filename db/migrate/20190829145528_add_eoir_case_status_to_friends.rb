class AddEoirCaseStatusToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :eoir_case_status, :string
  end
end
