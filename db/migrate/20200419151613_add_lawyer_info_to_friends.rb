class AddLawyerInfoToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :has_a_lawyer, :boolean
    add_column :friends, :lawyer_name, :string
  end
end
