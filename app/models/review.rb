class Review < ApplicationRecord
  belongs_to :draft
  belongs_to :user

  validates :user, uniqueness: { scope: :draft,
                                 message: "You already have a review for this draft" }
end
