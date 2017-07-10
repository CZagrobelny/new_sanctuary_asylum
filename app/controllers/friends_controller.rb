class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_friend, only: [:update, :show]

  def index
    @friends = current_user.friends
  end

  def show
    @friend = Friend.find(params[:id])
  end

  def update
    @friend = Friend.find(params[:id])
    @friend.update(friend_params)
    respond_to do |format|
      format.js { render :file => 'friends/asylum', locals: {friend: @friend}}
    end
  end

  private
  def require_access_to_friend
    unless UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?
      not_found
    end
  end

  def friend_params
    params.require(:friend).permit(
      :user_ids => []
    )
  end
end