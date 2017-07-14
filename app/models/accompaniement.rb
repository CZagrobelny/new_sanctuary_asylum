class Accompaniement < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  def self.find_or_build(activity, user)
    user.attending?(activity) ? Accompaniement.where(user_id: user.id, activity_id: activity.id).first : user.accompaniements.new(activity_id: activity.id)
  end
end
