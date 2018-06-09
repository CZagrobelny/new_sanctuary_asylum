class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community

  def index
    redirect_to community_admin_path(current_community.slug) if current_user.admin?
  end
end
