class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_primary_community
  before_action :require_access_to_community

  def index
    week1, week2 = DatesHelper.two_weeks
    if listed_activities_are_at_end_of_month(week2) and next_month_has_posted_activities(week2)
      flash[:success] = "Accompaniments posted for next month! Click 'Next' in the calendar to view future accompaniments."
    end
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                                             week1.begin,
                                                             week2.end)
                                         .includes(:accompaniments, :users, :friend, :location)
  end

  private

  def listed_activities_are_at_end_of_month(week2)
    week2.include?(week2.end.end_of_month)
  end

  def next_month_has_posted_activities(week2)
    next_month_activities = current_region.activities.for_next_month(Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                                                      week2.end.next_month)
    
    next_month_activities.any?
  end
end
