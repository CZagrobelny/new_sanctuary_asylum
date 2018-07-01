class LawyerMailer < ApplicationMailer

  def review_needed_email(draft)
    @draft = draft
    emails = draft.friend.remote_clinic_lawyers.map(&:email)
    mail(to: emails, 
         body: review_needed_body(draft), 
         content_type: "text/html",
         subject: "Review needed", )
  end


  private

  def review_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review."
  end
end
