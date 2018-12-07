class FamilyCourtCap < ActiveRecord::Migration[5.0]
  def change
    fc_act_type = ActivityType.find_by(name: 'family_court')
    if fc_act_type
      fc_act_type.cap = 2
      fc_act_type.save
    end
  end
end
