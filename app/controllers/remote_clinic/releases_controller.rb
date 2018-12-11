class RemoteClinic::ReleasesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_friend

  def new
    friend
    @release ||= friend.releases.build
  end

  def create
    @release = friend.releases.build(release_params)
    if @release.save
      flash[:success] = 'Release saved'
      redirect_to remote_clinic_friend_path(friend)
    else
      flash.now[:error] = 'Release not saved'
      render :new
    end
  end

  def destroy
    release.destroy
    flash[:success] = 'Release deleted'
    redirect_to remote_clinic_friends_path
  end

  private

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  def release
    @release ||= current_user.releases.find_by(friend: friend)
  end

  def require_access_to_friend
    return not_found unless current_user.existing_remote_relationship?(params[:friend_id])
  end

  def release_params
    params.require(:release).permit(
      :category,
      :release_form
    ).merge(user_id: current_user.id)
  end
end
