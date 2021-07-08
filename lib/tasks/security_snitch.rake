desc 'Alert for regional admins without 2Fac enabled'
task security_snitch: :environment do
    # lol this can't possibly be the most efficient fetch D:
    Region.all.each do |region|
        admins = User
            .where(role: ['admin', 'data_entry', 'eoir_caller'])
            .where('authy_enabled = ? OR agreed_to_data_entry_policies = ?', false, false)
            .where(community_id: [region.communities.pluck(:id)])
        
        if admins.any?
            target_admin_emails = region.regional_admins.pluck(:email)
            UserMailer.insecure_admins_email(target_admin_emails, admins)

            # Just logging for documentation
            message = 'The following admins do not have 2FAC authy enabled: '
            admins.each do |admin|
                message += "\n  - " + admin.name + '(' + admin.email + '): '
                if !admin.authy_enabled
                    message += 'Authy: NOT ENABLED, '
                end
                if !admin.agreed_to_data_entry_policies
                    message += 'Data Entry Policies: NOT AGREED'
                end
            end
            puts message
        end
    end
end
