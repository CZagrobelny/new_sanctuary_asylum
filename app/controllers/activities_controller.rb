class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    @upcoming_activities = current_region.activities.upcoming_two_weeks
  end
end