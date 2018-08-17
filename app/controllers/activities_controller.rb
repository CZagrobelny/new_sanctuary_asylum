class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_primary_community
  before_action :require_access_to_community

  def index
    week1, week2 = DatesHelper.two_weeks
    @upcoming_activities = current_region.activities
                                         .for_time_confirmed(Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                                             week1.begin,
                                                             week2.end)
                                         .includes(:accompaniments, :users, :friend, :location)
  end
end
