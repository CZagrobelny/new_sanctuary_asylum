class AddInvitedToSpeakToALawyerToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :invited_to_speak_to_a_lawyer, :boolean
  end
end
