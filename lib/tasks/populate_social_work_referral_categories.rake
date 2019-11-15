SOCIAL_WORK_REFERRAL_CATEGORIES = ['Shelter/housing', 'Health Care Services' ,'Mental Health Services', 'Advocacy Services', 'Psychiatric Evaluation for Immigration Case', 'ESL', 'Nutrition Services', 'Public Benefits', 'IDNYC']

desc 'Populate social work referral categories table'
task populate_social_work_referral_categories: :environment do
    SocialWorkReferralCategory.destroy_all
    SOCIAL_WORK_REFERRAL_CATEGORIES.each do |category|
        SocialWorkReferralCategory.create(name: category)
    end
end