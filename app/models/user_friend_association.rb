class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend

  before_save :set_remote_flag
  after_create :remote_lawyer_invitation, if: proc { |friendship| friendship.remote? }

  scope :remote, -> { where(remote: true) }

  def set_remote_flag
    self.remote = user.remote_clinic_lawyer?
  end

  def remote_lawyer_invitation
    FriendshipAssignmentMailer.send_assignment_email(user, friend).deliver_now
  end
end
