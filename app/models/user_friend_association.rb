class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend

  after_create :remote_lawyer_invitation, if: Proc.new { |friendship| friendship.remote? }

  def remote_lawyer_invitation
    User.invite!(email: self.user.email)
  end
end
