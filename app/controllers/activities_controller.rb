class ActivitiesController < ApplicationController
  def index
    @current_week_activities = Activity.accompaniement_eligible.current_week
    @next_week_activities = Activity.accompaniement_eligible.next_week
  end
end