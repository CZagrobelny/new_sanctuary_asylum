class Accompaniment < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validate :volunteer_cap_not_exceeded
  validate :not_associated_with_combined_child

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

  def not_associated_with_combined_child
    if activity&.combined_activity_parent
      errors.add(:combined_activity_parent, "can't be associated with a combined activity child")
      false
    end
  end
end
