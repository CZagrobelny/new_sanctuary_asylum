class CreateFriendSocialWorkReferralCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_social_work_referral_categories do |t|
      t.belongs_to :friend, :null => false
      t.belongs_to :social_work_referral_categories, index: { name: :index_fswrc_on_swrc_id }, :null => false

      t.timestamps :null => false
    end
  end
end
