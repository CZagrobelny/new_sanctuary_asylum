class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_access_to_friend, only: [:update, :show]

  def index
    @friends = current_user.friends.order('first_name asc')
  end

  def show
    friend
    @current_tab = current_tab
  end

  def update
    friend.update(friend_params)
    respond_to do |format|
      format.js { render :file => 'friends/access', locals: {friend: friend} }
    end
  end

  private
  def require_access_to_friend
    unless UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?
      not_found
    end
  end

  def friend
    @friend ||= current_user.friends.find(params[:id])
  end

  def friend_params
    params.require(:friend).permit(
      :user_ids => []
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