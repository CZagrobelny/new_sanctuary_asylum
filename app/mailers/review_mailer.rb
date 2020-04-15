class ReviewMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def changes_requested_email(review)
    @review = review
    friend = review.draft.friend
    emails = friend.users.where(user_friend_associations: { remote: false }).pluck(:email)
    @link_url = community_friend_draft_review_url(friend.community.slug, friend, review.draft, review)
    mail(to: emails, subject: "New review on #{friend.first_name}'s application")
  end

  def application_approved_email(application)
    @application = application
    friend = application.friend
    emails = friend.users.where(user_friend_associations: { remote: false }).pluck(:email)
    @link_url = community_friend_url(friend.community.slug, friend)
    mail(to: emails, subject: "A draft of #{friend.first_name}'s application has been approved ")
  end
end
