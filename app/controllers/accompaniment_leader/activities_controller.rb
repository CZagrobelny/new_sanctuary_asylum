class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController

  def index
    @upcoming_activities = current_region.activities.upcoming_two_weeks
  end
end