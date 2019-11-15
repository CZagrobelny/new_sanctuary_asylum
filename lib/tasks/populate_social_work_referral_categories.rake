SOCIAL_WORK_REFERRAL_CATEGORIES = [
    'Advocacy Services',
    'ESL',
    'Health Care Services',
    'IDNYC',
    'Mental Health Services',
    'Nutrition Services',
    'Psychiatric Evaluation for Immigration Case',
    'Public Benefits',
    'Shelter/housing'
]

desc 'Populate social work referral categories table'
task populate_social_work_referral_categories: :environment do
    SocialWorkReferralCategory.destroy_all
    SOCIAL_WORK_REFERRAL_CATEGORIES.each do |category|
        SocialWorkReferralCategory.create(name: category)
    end
end