class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend

  after_create :remote_lawyer_invitation, if: proc { |friendship| friendship.remote? }

  scope :remote, -> { where(remote: true) }

  def remote_lawyer_invitation
    FriendshipAssignmentMailer.send_assignment_email(user, friend).deliver_now
  end
end
