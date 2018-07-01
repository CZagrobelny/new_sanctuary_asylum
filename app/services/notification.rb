class Notification

  def self.draft_for_review(draft: nil)
    if draft.in_review? && draft.friend.remote_clinic_lawyers.present?
      LawyerMailer.review_needed_email(draft).deliver_now
    elsif draft.in_review?
      RegionalAdminMailer.review_needed_email(draft).deliver_now
    end
  end
end
