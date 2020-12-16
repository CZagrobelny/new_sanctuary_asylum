class RemoteReviewAction < ApplicationRecord
  belongs_to :friend, dependent: :destroy
  belongs_to :community
  belongs_to :region
  belongs_to :user
  belongs_to :application
  belongs_to :draft, optional: true

  validates :friend, :community, :region, :user, :application, :action, presence: true
  validates_inclusion_of :action, in: %w[review_requested review_added approved closed]
end
