# Options
# 1. Make `belongs_to :activity` polymorphic, possibly mapping to Carpool. Requires renaming.
#    Trouble here is naming. `activity_type` is already spoken for, m/w there's not much more
#    generic than `activity`. `event` is also spoken for. S/t like `accompaniment_need` could work, but
#    this language is awkward / indirect.
#      No: activity, event, accompaniment_need,
#
# 2. Create second `belongs_to :carpool` and both are optional. Disadvantages include: `if` conditional
#    everythwere .activity is now used (nowhere..)

# Choice to have two optional belongs_to is part semantic and part rational.

# Semantic: Naming things is important. In the application vocab, event and activity are both taken. There is little
# which is more generic than that.

# Rational: Activity is already as generic as it gets. Activities have types. Accompanying for an accompaniment-
# eligible activity already covers the gamut of possible accompaniments. In other words, creating a polymorphic
# association from the accopmaniments table to "anything" is redundant and unneeded complexity: activities already
# are "anything." We only need one more possible association, which is the carpool (a grouping of N activities of X
# types.) Done!

class Accompaniment < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validate :volunteer_cap_not_exceeded
  validate :not_associated_with_combined_accompaniment_child

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

  def not_associated_with_combined_accompaniment_child
    if activity.combined_accompaniment_activity_parent?
      errors.add(:combined_accompaniment_activity_parent, "can't associated accompaniment with a combined activity child")
      false
    end
  end
end
