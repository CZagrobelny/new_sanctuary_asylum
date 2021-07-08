class UserMailer < ApplicationMailer
  def account_lockdown_email(user)
    @user = user
    admin_emails = user.community.region.regional_admins.pluck(:email)
    return unless admin_emails.present?

    mail(to: admin_emails, subject: "Account lockdown warning")
  end

  def insecure_admins_email(target_admin_emails, insecure_admins)
    @insecure_admins = insecure_admins
    mail(to: target_admin_emails, subject: "Report: Insecure Region Admins -- Fix ASAP")
  end
end
