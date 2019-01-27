class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_primary_community
  before_action :require_access_to_community

  def index
    week1, week2 = DatesHelper.two_weeks

    if listed_activities_are_at_end_of_month(week1, week2) and next_month_has_posted_activities(week2)
      flash[:success] = "Accompaniments posted for next month! Click 'Next' in the calendar to view future accompaniments."
    end
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(week1.begin, week2.end)
                                         .includes(:accompaniments, :users, :friend, :location)
  end

  private

  def listed_activities_are_at_end_of_month(week1, week2)
    week1.include?(week1.begin.end_of_month) || week2.include?(week2.begin.end_of_month)
  end

  def next_month_has_posted_activities(week2)
    current_region.activities.for_time_confirmed(week2.begin.beginning_of_month, week2.end).any?
  end
end
