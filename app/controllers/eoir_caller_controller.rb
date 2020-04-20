class EoirCallerController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_active_eoir_caller_timeslot

  private
  def require_active_eoir_caller_timeslot
    unless current_user.has_active_eoir_caller_access_time_slot?
      not_found
    end
  end
end