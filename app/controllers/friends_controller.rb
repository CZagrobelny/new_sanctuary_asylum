class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.friends
  end

  def show
    @friend = Friend.find(params[:id])
  end
end