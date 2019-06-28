class Review < ApplicationRecord
  belongs_to :draft
  belongs_to :user

  VALIDATION_MESSAGE = 'You already have a review for this draft'.freeze

  validates :user_id, uniqueness: { scope: :draft_id,
                                    message: VALIDATION_MESSAGE }
  validates :notes, presence: true

  scope :by_user, ->(user) {
    where(user: user)
  }

  def authored_by?(user)
    !self.user.nil? && self.user == user
  end

  def save_and_note_changes_requested
    transaction do
      save!
      draft.update!(status: :changes_requested)
      draft.application.update!(status: :changes_requested)
    end
    true
  rescue
    false
  end
end
