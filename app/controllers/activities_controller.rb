class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  def index
    @upcoming_activities = Activity.upcoming_two_weeks
  end
end