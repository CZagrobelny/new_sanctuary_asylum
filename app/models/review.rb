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

  def save_and_note_review_added
    transaction do
      save!
      draft.update!(status: :review_added)
      draft.application.update!(status: :review_added)
    end
    true
  rescue
    false
  end
end
