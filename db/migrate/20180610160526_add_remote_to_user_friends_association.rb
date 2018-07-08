class AddRemoteToUserFriendsAssociation < ActiveRecord::Migration[5.0]
  def change
    add_column :user_friend_associations, :remote, :boolean, default: false
  end
end
