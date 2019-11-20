class AddSocialWorkReferralNotesToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :social_work_referral_notes, :text
  end
end
