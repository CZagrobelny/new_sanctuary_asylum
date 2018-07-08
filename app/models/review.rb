class Review < ApplicationRecord
  belongs_to :draft
  belongs_to :user

  validates :user, uniqueness: { scope: :draft,
                                 message: "You already have a review for this draft" }

  scope :by_user, ->(user) {
    where(user: user)
  }

  def authored_by?(user)
    !self.nil? && self.user == user
  end
end
