class RemoteClinic::FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_friend, only: [:show]

  def index
    @friends = current_user.remote_clinic_friends
  end

  def show
    friend
  end

  private

  def require_access_to_friend
    return not_found unless current_user.existing_remote_relationship?(params[:id])
  end

  def friend
    @friend ||= Friend.find_by_id(params[:id])
  end
end
