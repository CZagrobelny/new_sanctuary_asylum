class FriendshipAssignmentMailer < ApplicationMailer
  def send_assignment_email(user, friend)
    @friend = friend
    mail(to: user.email, subject: 'Friend assignment')
  end
end
