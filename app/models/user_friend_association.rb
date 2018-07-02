class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend

  after_create :remote_lawyer_invitation, if: Proc.new { |friendship| friendship.remote? }

  def remote_lawyer_invitation
    FriendshipAssignmentMailer.send_assignment(user, friend)
  end
end
