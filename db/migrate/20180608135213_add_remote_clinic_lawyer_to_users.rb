class AddRemoteClinicLawyerToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :remote_clinic_lawyer, :boolean
  end
end
