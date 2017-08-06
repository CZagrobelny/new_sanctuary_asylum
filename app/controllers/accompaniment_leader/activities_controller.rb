class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController
  def index
    @upcoming_activities = Activity.upcoming_two_weeks
  end
end