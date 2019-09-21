class Carpool < ApplicationRecord
  has_many :activities, -> { order(occur_at: :asc) }
  has_many :accompaniments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :accompaniments

  def location
    activities.map(&:location).join(', ')
  end

  def occur_at
    activities.first.occur_at
  end

  def accompaniment_eligible?
    true
  end
end
