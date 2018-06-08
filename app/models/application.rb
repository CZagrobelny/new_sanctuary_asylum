class Application < ApplicationRecord
  has_many :drafts
  belongs_to :friend

  validates :category, presence: true

  enum status: [ :in_progress, 
                 :in_review,
                 :changes_requested,
                 :approved,
                 :closed ]

end
