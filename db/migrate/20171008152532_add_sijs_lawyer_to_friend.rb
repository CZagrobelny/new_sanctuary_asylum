class AddSijsLawyerToFriend < ActiveRecord::Migration[5.0]
  def change
    add_column :friends, :sijs_lawyer, :integer
  end
end
