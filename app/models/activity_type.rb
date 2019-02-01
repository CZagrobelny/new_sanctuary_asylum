class ActivityType < ApplicationRecord
  validates :name, presence: true

  scope :by_name, -> {
    order('name asc')
  }

  def title_name
    name.titlecase
  end
end
