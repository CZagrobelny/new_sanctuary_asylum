class RemoteReviewAction < ApplicationRecord
  belongs_to :friend, dependent: :destroy
  belongs_to :community
  belongs_to :region
  belongs_to :user

  validates :friend, :community, :region, :user, :action
  validates_inclusion_of :action, in: %w[review_requested, review_added, approved, closed]
end
