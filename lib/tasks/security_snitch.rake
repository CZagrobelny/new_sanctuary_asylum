desc 'Alert for regional admins without 2Fac enabled'
task security_snitch: :environment do
    # .or(agreed_to_data_entry_policies: false)
    admins = User
        .where(role: ['admin', 'data_entry', 'eoir_caller'])
        .where(authy_enabled: false)
        .or(User.where(agreed_to_data_entry_policies: false))
        .includes(:community)
    
    message = 'The following admins do not have 2FAC authy enabled: '
    admins.each do |admin|
    message += '\n  - ' + admin.name + '(' + admin.email + '): '
    if !admin.authy_enabled
        message += 'Authy: NOT ENABLED, '
    end
    if !admin.agreed_to_data_entry_policies
        message += 'Data Entry Policies: NOT AGREED,'
    end

    puts message
  end
end
