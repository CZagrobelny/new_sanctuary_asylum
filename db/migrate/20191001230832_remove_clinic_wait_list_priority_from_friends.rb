class RemoveClinicWaitListPriorityFromFriends < ActiveRecord::Migration[5.2]
  def change
    remove_column :friends, :clinic_wait_list_priority
  end
end
