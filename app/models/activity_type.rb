class ActivityType < ApplicationRecord
  validates :name, presence: true

  def title_name
    name.titlecase
  end
end
