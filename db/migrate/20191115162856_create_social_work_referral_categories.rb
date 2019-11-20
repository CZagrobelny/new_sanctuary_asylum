class CreateSocialWorkReferralCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :social_work_referral_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
