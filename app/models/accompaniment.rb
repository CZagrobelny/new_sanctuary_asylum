class Accompaniment < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :activity_id, :user_id, presence: true
  validate :limit_for_family_court

  def self.find_or_build(activity, user)
    if user.attending?(activity)
      Accompaniment.where(user_id: user.id, activity_id: activity.id).first
    else
      user.accompaniments.new(activity_id: activity.id)
    end
  end

  private

  def limit_for_family_court
    if !activity.try(:accompaniable?)
      errors.add(:activity, family_court_error)
      false
    end
  end

  def family_court_error
    "Only 3 accompaniments are allowed per family_court activity"
  end

end
