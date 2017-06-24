class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  private 
  def require_admin
    not_found unless current_user.admin?
  end
end
