class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to community_admin_path(current_community.slug) if current_user.admin?
  end

end