class Accompaniment < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :activity_id, :user_id, presence: true
  validate :volunteer_cap_not_exceeded

  def self.find_or_build(activity, user)
    if user.attending?(activity)
      Accompaniment.where(user_id: user.id, activity_id: activity.id).first
    else
      user.accompaniments.new(activity_id: activity.id)
    end
  end

  private

  def volunteer_cap_not_exceeded
    if user.try(:volunteer?) && activity.try(:accompaniment_limit_met?)
      errors.add(:activity, volunteer_cap_exceeded)
      false
    end
  end

  def volunteer_cap_exceeded
    "can't exceed #{activity.activity_type.cap} volunteer accompaniments."
  end
end
