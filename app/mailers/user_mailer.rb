class UserMailer < ApplicationMailer
  def account_lockdown_email(user)
    @user = user
    admin_emails = user.community.region.regional_admins.pluck(:email)
    return unless admin_emails.present?

    mail(to: admin_emails, subject: "Account lockdown warning")
  end
end
