class UserFriendAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :friend

  before_save :set_remote_flag

  scope :remote, -> { where(remote: true) }

  def set_remote_flag
    self.remote = user.remote_clinic_lawyer?
  end
end
