class SocialWorkReferralCategory < ApplicationRecord
    has_many :friend_social_work_referral_categories, dependent: :destroy
    has_many :friends, through: :friend_social_work_referral_categories
end
