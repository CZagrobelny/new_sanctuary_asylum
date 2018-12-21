class ReviewMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def review_needed_email(draft)
    @draft = draft
    emails = draft.friend.remote_clinic_lawyers.map(&:email)
    @link_url = remote_clinic_friend_url(draft.friend)
    mail(to: emails, subject: "Review needed", )
  end

  def lawyer_assignment_needed_email(draft)
    @draft = draft
    emails = draft.friend.region.regional_admins.map(&:email)
    @link_url = regional_admin_region_friend_url(draft.friend.region, draft.friend)
    mail(to: emails, subject: "Lawyer assignment needed", )
  end

  def changes_requested_email(review)
    @review = review
    friend = review.draft.friend
    emails = (friend.users.where(user_friend_associations: { remote: false }).map(&:email)).flatten
    @link_url = community_friend_draft_review_url(friend.community.slug, friend, review.draft, review)
    mail(to: emails, subject: "Changes requested on #{friend.first_name}'s application", )
  end

  def application_approved_email(application)
    @application = application
    friend = application.friend
    emails = (friend.users.where(user_friend_associations: { remote: false }).map(&:email)).flatten
    @link_url = community_friend_url(friend.community.slug, friend)
    mail(to: emails, subject: "A draft of #{friend.first_name}'s application has been approved ", )
  end
end
