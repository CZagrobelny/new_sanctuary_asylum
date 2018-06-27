class FriendshipAssignmentMailer < Devise::Mailer
  default template_path: 'devise/mailer/friendships'

  def send_assignment(user, friend)
    @friend = friend
    mail to: user.email, subject: 'Friend assignment'
  end
end
