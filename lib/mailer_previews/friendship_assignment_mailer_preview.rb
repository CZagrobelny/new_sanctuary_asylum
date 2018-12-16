class FriendshipAssignmentMailerPreview < ActionMailer::Preview
  def send_assignment_email
    FriendshipAssignmentMailer.send_assignment_email(User.first, Friend.first)
  end
end
