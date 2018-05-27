class ApplicationDraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_access_to_friend
  before_action :require_admin, only: [:destroy]

  def new
    @application_draft = friend.application_drafts.new
  end

  def create
    @application_draft = friend.application_drafts.new(application_draft_params)
    if @application_draft.save
      flash[:success] = 'Application draft saved.'
      render_success
    else
      flash.now[:error] = 'Application draft not saved.'
      render :new
    end
  end

  def edit
    application_draft
    friend
  end

  def update
    if application_draft.update(application_draft_params)
      flash[:success] = 'Application draft saved.'
      render_success
    else
      friend
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def index
    friend
  end

  def destroy
    if application_draft.destroy
      flash[:success] = 'Application draft destroyed.'
      redirect_to edit_community_admin_friend_path(current_community, friend, tab: '#documents')
    else
      flash[:error] = 'Error destroying application draft.'
      redirect_to community_friend_application_drafts_path(current_community, friend)
    end
  end

  def render_success
    if current_user.admin?
      redirect_to edit_community_admin_friend_path(current_community, friend, tab: '#documents')
    else
      redirect_to community_friend_path(current_community, friend, tab: '#documents')
    end
  end

  def application_draft
    @application_draft ||= ApplicationDraft.find(params[:id])
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  private
  def application_draft_params
    params.require(:application_draft).permit(
      :notes,
      :pdf_draft,
      :category,
      :user_ids => []
    )
  end

  def require_admin_or_access_to_friend
    unless current_user.admin? || UserFriendAssociation.where(friend_id: params[:friend_id], user_id: current_user.id).present?
      not_found
    end
  end
end
