class ReviewMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def review_needed_email(draft)
    @draft = draft
    emails = draft.friend.remote_clinic_lawyers.map(&:email)
    mail(to: emails,
         content_type: "text/html",
         subject: "Review needed",
         body: review_needed_body(draft), )
  end

  def lawyer_assignment_needed_email(draft)
    @draft = draft
    emails = draft.friend.region.regional_admins.map(&:email)
    mail(to: emails,
         subject: "Lawyer assignment needed",
         body: lawyer_assignment_needed_body(draft), )
  end

  def changes_requested(review)
    friend = review.draft.friend
    emails = (friend.community.region.regional_admins.map(&:email) + friend.users.where(user_friend_associations: { remote: false }).map(&:email)).flatten
    mail(to: emails,
         subject: "Changes requested on #{friend.first_name}'s application",
         body: changes_requested_body(review, friend), )
  end

  def application_approved(application)
    friend = application.friend
    emails = (friend.community.region.regional_admins.map(&:email) + friend.users.where(user_friend_associations: { remote: false }).map(&:email)).flatten
    mail(to: emails,
         subject: "A draft of #{friend.first_name}'s application has been approved ",
         body: application_approved_body(application, friend), )
  end

  private

  # TODO (TC): Put this path in: remote_clinic_friend_path(user_id: user_id, id: friend_id)
  def review_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review."
  end

  # TODO (TC): Put this path in: regional_admin_region_friend_path(region, friend)
  def lawyer_assignment_needed_body(draft)
    "#{draft.friend.first_name}'s #{draft.application.category} application draft has been submitted for review and is awaiting lawyer assignment."
  end

  # TODO (TC): Put this path in: community_friend_path(community.slug, friend)
  def changes_requested_body(review, friend)
    "#{friend.first_name}'s #{review.draft.application.category} application draft has recieved a review: #{community_friend_draft_review_url(friend.community.slug, friend, review.draft, review)}."
  end

  # TODO (TC): Put this path in: community_friend_path(community.slug, friend)
  def application_approved_body(application, friend)
    "#{friend.first_name}'s #{application.category} application has an approved draft!"
  end
end
