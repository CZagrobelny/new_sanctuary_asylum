class Release < ApplicationRecord
  TYPES = %w[
    limited_scope
  ].freeze

  belongs_to :friend
  belongs_to :user # Validation below that this user is a lawyer

  mount_uploader :release_form, ReleaseFormUploader

  validates :release_form, :friend, presence: true
  validates :category, presence: true, inclusion: { in: TYPES }, uniqueness: { scope: %i[friend_id user_id] }
  validate :user_is_allowed_role

  private

  # This is probably going to need to allow multiple roles/types
  def user_is_allowed_role
    return unless user

    errors.add(:user, 'is not authorized to sign releases') unless user.remote_clinic_lawyer?
  end
end
