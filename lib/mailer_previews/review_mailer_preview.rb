class ReviewMailerPreview < ActionMailer::Preview
  def review_added_email
    ReviewMailer.review_added_email(Review.last)
  end

  def application_approved_email
    ReviewMailer.application_approved_email(Application.last)
  end
end
