class FriendshipAssignmentMailer < ApplicationMailer

  def send_assignment(user, friend)
    @friend = friend
    mail(to: user.email,
         body: send_assignment_body(@friend.first_name),
         content_type: "text/html",
         subject: "Friend assignment", )
  end

  # TODO (TC): Put this path in: remote_clinic_friend_path(user_id: user_id, id: friend_id)
  private
  def send_assignment_body(first_name)
    "You have been assigned to review #{first_name}'s applications"
  end
end
