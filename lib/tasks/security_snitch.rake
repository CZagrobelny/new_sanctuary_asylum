desc 'Alert for regional admins without 2Fac enabled'
task security_snitch: :environment do
  Region.all.each do |region|
    admins = User
      .where(role: 'admin')
      .where('authy_enabled = ? OR agreed_to_data_entry_policies = ?', false, false)
      .where(community_id: [region.communities.pluck(:id)])

    if admins.any?
      region.regional_admins.each do |regional_admin|
        UserMailer.insecure_admins_email(region, regional_admin.email, admins).deliver_now
      end
    end
  end
end
