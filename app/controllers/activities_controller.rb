class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_primary_community
  before_action :require_access_to_community

  def index
    @upcoming_activities = current_region.activities.upcoming_two_weeks(region: current_region)
  end
end
