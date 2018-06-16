class RegionalAdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :require_access_to_region

  private
  def require_access_to_region
    not_found unless current_user.can_access_region?(current_region)
  end
end