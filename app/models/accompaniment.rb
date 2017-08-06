class Accompaniment < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  validates :activity_id, :user_id, presence: true

  def self.find_or_build(activity, user)
    user.attending?(activity) ? Accompaniment.where(user_id: user.id, activity_id: activity.id).first : user.accompaniments.new(activity_id: activity.id)
  end
end
