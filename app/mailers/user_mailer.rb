class UserMailer < ApplicationMailer
  def account_lockdown_email(user)
    @user = user
    admin_emails = user.community.region.regional_admins.pluck(:email)
    return unless admin_emails.present?

    mail(to: admin_emails, subject: "Account lockdown warning")
  end

  def insecure_admins_email(region, regional_admin_email, insecure_admins)
    @insecure_admins = insecure_admins
    mail(to: regional_admin_email, subject: "ACTION REQUIRED: #{ region.name } admins are out of compliance with digital security requirements")
  end
end
