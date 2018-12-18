class ActivityType < ApplicationRecord
  validates :name, presence: true

  scope :accompaniment_eligible, -> {
    where(accompaniment_eligible: true).map { |a_t| a_t.name }
  }

  scope :non_accompaniment_eligible, -> {
    where(accompaniment_eligible: false).map { |a_t| a_t.name }
  }

  def title_name
    name.titlecase
  end
end
