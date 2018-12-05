class Release < ApplicationRecord
  TYPES = %w{
    limited_scope
  }.freeze

  belongs_to :friend
  belongs_to :user # Validation below that this user is a lawyer

  mount_uploader :release_form, ReleaseFormUploader

  validates :release_form, :friend, presence: true
  validates :category, presence: true, inclusion: { in: TYPES }, uniqueness: { scope: [:friend_id, :user_id] }
  validate :user_is_lawyer

  private

  def user_is_lawyer
    return unless user
    errors.add(:user, 'must be lawyer') unless user.volunteer_type == 'lawyer'
  end
end
