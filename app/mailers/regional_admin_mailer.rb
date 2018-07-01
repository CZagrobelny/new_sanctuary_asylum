class RegionalAdminMailer < ApplicationMailer

  def review_needed_email(draft)
    @draft = draft
    emails = draft.friend.region.regional_admins.map(&:email)
    mail(to: emails, subject: "Review needed", body: review_needed_body(draft))
  end


  private

  def review_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment."
  end

end
