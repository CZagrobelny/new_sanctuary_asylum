class AccompanimentLeaderController < ApplicationController
  before_action :authenticate_user!
  before_action :require_accompaniment_leader_or_eoir_caller
  before_action :require_access_to_community
  before_action :require_primary_community

  private

  def require_accompaniment_leader_or_eoir_caller
    return if current_user.accompaniment_leader? || current_user.eoir_caller?

    render not_found
  end
end
