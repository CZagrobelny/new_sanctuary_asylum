class RemoveRemoteClinicLawyersFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :remote_clinic_lawyer
  end
end
