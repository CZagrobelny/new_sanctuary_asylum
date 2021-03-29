class DropFriendSocialWorkReferralCategories < ActiveRecord::Migration[6.0]
  def self.up
    drop_table :friend_social_work_referral_categories
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
