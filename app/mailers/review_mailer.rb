class ReviewMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def review_added_email(review)
    @review = review
    friend = review.draft.friend
    emails = friend.users.where(user_friend_associations: { remote: false }).pluck(:email)
    mail(to: emails, subject: "New review on #{friend.first_name}'s application")
  end

  def application_approved_email(application)
    @application = application
    friend = application.friend
    emails = friend.users.where(user_friend_associations: { remote: false }).pluck(:email)
    mail(to: emails, subject: "A draft of #{friend.first_name}'s application has been approved ")
  end
end
