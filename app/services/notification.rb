class Notification

  def self.draft_for_review(draft: nil)
    if draft.in_review? && draft.friend.remote_clinic_lawyers.present?
      ReviewMailer.review_needed_email(draft).deliver_now
    elsif draft.in_review?
      ReviewMailer.lawyer_assignment_needed_email(draft).deliver_now
    end
  end
end
