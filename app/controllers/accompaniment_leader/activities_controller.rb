class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController
  def index
    start_date, end_date = DatesHelper.five_weeks
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(start_date, end_date)
                                         .includes(:accompaniments, :users, :accompaniment_reports, :friend, :location)
  end
end
