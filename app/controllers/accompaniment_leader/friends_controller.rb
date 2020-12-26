class AccompanimentLeader::FriendsController < AccompanimentLeaderController
  before_action :require_accompaniment_leader_access
  before_action :restrict_access_to_archived_friend, only: [:show]

  def show
  end

  private

  def friend
    @friend ||= Friend.find(params[:id])
  end

  def require_accompaniment_leader_access
    start_date, end_date = DatesHelper.five_weeks
    activities = friend.activities
      .for_time_confirmed(start_date, end_date)

    activities.each do |activity|
      return if current_user.attending?(activity)
    end

    not_found
  end
end
