class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController
  def index
    week1, week2 = DatesHelper.two_weeks
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                                             week1.begin,
                                                             week2.end)
  end
end
