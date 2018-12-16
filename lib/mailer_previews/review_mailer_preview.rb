class ReviewMailerPreview < ActionMailer::Preview
  def review_needed_email
    ReviewMailer.review_needed_email(Draft.first)
  end

  def lawyer_assignment_needed_email
    ReviewMailer.lawyer_assignment_needed_email(Draft.first)
  end

  def changes_requested_email
    ReviewMailer.changes_requested_email(Review.last)
  end

  def application_approved_email
    ReviewMailer.application_approved_email(Application.last)
  end
end
