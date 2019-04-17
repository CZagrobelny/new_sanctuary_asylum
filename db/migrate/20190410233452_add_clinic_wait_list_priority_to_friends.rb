class AddClinicWaitListPriorityToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :clinic_wait_list_priority, :integer
  end
end
