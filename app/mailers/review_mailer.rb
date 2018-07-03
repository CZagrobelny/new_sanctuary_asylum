class ReviewMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def review_needed_email(draft)
    @draft = draft
    emails = draft.friend.remote_clinic_lawyers.map(&:email)
    mail(to: emails,
         body: review_needed_body(draft),
         content_type: "text/html",
         subject: "Review needed", )
  end

  def lawyer_assignment_needed_email(draft)
    @draft = draft
    emails = draft.friend.region.regional_admins.map(&:email)
    mail(to: emails, subject: "Lawyer assignment needed", body: lawyer_assignment_needed_body(draft))
  end

  def changes_requested(review)
    friend = review.draft.friend
    emails = (friend.community.users.where(role: 'admin').map(&:email) + friend.users.where(user_friend_associations: { remote: false }).map(&:email)).flatten
    mail(to: emails, subject: "Changes requested on #{friend.first_name}'s application", body: changes_requested_body(review, friend))
  end

  private

  def review_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review."
  end

  def lawyer_assignment_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment."
  end

  def changes_requested_body(review, friend)
    "#{friend.first_name}'s #{review.draft.application.category} application draft has recieved a review: #{community_friend_draft_review_url(friend.community.slug, friend, review.draft, review)}."
  end
end
