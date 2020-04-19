class ReviewMailerPreview < ActionMailer::Preview
  def changes_requested_email
    ReviewMailer.changes_requested_email(Review.last)
  end

  def application_approved_email
    ReviewMailer.application_approved_email(Application.last)
  end
end
