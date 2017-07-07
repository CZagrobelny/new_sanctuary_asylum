class AddLawyerToFriend < ActiveRecord::Migration[5.0]
  def change
  	add_column :friends, :lawyer_referred_to, :integer
  	add_column :friends, :lawyer_represented_by, :integer
  end
end
