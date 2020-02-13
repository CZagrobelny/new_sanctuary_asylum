class AddClinicPlanToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :clinic_plan, :string
  end
end
