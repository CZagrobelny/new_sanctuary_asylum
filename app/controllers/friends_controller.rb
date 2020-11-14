class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_access_to_friend, only: %i[update show]

  def index
    @friends = current_user.friends.order('first_name asc')
  end

  def show
    friend
    @current_tab = current_tab
  end

  def update
    update_friend_params = friend_params
    update_friend_params[:user_ids] = (Array(friend_params[:user_ids]) + friend.remote_clinic_lawyers.pluck(:id)).flatten.compact
    friend.update(update_friend_params)
    respond_to do |format|
      format.js { render template: 'friends/access', locals: { friend: friend } }
    end
  end

  private

  def require_access_to_friend
    not_found unless UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?
  end

  def friend
    @friend ||= current_user.friends.find(params[:id])
  end

  def friend_params
    params.require(:friend).permit(
      user_ids: []
    )
  end

  def current_tab
    if params[:tab].present?
      params[:tab]
    else
      '#basic'
    end
  end
end
