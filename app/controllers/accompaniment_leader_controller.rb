class AccompanimentLeaderController < ApplicationController
  before_action :authenticate_user!
  before_action :require_accompaniment_leader

  private 
  def require_accompaniment_leader
    not_found unless current_user.accompaniment_leader?
  end
end