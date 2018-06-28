class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community

  def index
    if current_user.admin?
      redirect_to community_admin_path(current_community.slug)
    elsif current_user.remote_clinic_lawyer?
      redirect_to remote_clinic_lawyers_user_friends_path(current_user)
    end
  end
end
