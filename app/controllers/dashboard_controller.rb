class DashboardController < ApplicationController
  def index
    redirect_to admin_path if current_user.admin?
  end
  
end