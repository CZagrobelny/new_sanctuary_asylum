class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController
  def index
    week1, week2 = DatesHelper.two_weeks
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(ActivityType.accompaniment_eligible,
                                                             week1.begin,
                                                             week2.end)
                                         .includes(:accompaniments, :users, :accompaniment_reports, :friend, :location)
  end
end
