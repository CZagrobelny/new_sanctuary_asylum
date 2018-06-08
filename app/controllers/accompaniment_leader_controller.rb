class AccompanimentLeaderController < ApplicationController
  before_action :authenticate_user!
  before_action :require_accompaniment_leader
  before_action :require_access_to_community
  before_action :require_primary_community

  private

  def require_accompaniment_leader
    not_found unless current_user.accompaniment_leader?
  end
end
