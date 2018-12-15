class ReleasesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_admin_or_access_to_friend

  def new
    friend
    @release ||= friend.releases.build
  end

  def create
    @release = friend.releases.build(release_params)
    if @release.save
      flash[:success] = 'Release saved'
      render_document_list
    else
      flash.now[:error] = 'Release not saved'
      render :new
    end
  end

  private

  def render_document_list
    if current_user.admin?
      redirect_to community_friend_drafts_path(current_community.slug, friend, tab: '#documents')
    else
      redirect_to community_friend_path(current_community.slug, friend, tab: '#documents')
    end
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def release_params
    params.require(:release).permit(
      :category,
      :release_form
    )
  end
end
