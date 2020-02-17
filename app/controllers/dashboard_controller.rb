class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin? || current_user.has_active_data_entry_access_time_slot?
      redirect_to community_admin_path(current_community.slug)
    elsif current_user.remote_clinic_lawyer?
      redirect_to remote_clinic_friends_path
    end
  end
end
