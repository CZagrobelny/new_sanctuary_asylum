class ActivitiesController < ApplicationController
  def index
    @upcoming_activities = Activity.upcoming_two_weeks
  end
end