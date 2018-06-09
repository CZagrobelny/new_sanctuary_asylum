class AccompanimentLeader::ActivitiesController < AccompanimentLeaderController
  def index
    if Date.today.cwday >= 5 && !Activity.remaining_this_week?
      week1 = (1.weeks.from_now.beginning_of_week.to_date..1.weeks.from_now.end_of_week.to_date)
      week2 = (2.weeks.from_now.beginning_of_week.to_date..2.weeks.from_now.end_of_week.to_date)
    else
      week1 = (Date.today.from_now.beginning_of_week.to_date..Date.today.from_now.end_of_week.to_date)
      week2 = (1.weeks.from_now.beginning_of_week.to_date..1.weeks.from_now.end_of_week.to_date)
    end
    @weeks = [week1, week2]
    @upcoming_activities = current_region.activities
                                         .for_week_confirmed(ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                                             week1.begin,
                                                             week2.end,
                                                             'asc')
    # @upcoming_activities = current_region.activities.upcoming_two_weeks(region: current_region)
  end
end
