class DraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_admin_or_access_to_friend
  before_action :require_admin, only: [:destroy]

  def new
    @draft = friend.drafts.new
  end

  def create
    application = friend.applications.find_or_initialize_by(category: draft_params[:category])
    @draft = application.drafts.new(draft_params.merge(friend: friend))
    if @draft.save
      flash[:success] = 'Application draft saved.'
      render_success
    else
      flash.now[:error] = 'Application draft not saved.'
      render :new
    end
  end

  def edit
    draft
    friend
  end

  def update
    if draft.update(draft_params)
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
    if draft.destroy
      flash[:success] = 'Application draft destroyed.'
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    else
      flash[:error] = 'Error destroying application draft.'
      redirect_to community_friend_drafts_path(current_community.slug, friend)
    end
  end

  def render_success
    if current_user.admin?
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    else
      redirect_to community_friend_path(current_community.slug, friend, tab: '#documents')
    end
  end

  def draft
<<<<<<< HEAD:app/controllers/drafts_controller.rb
    @draft ||= Draft.find(params[:id])
=======
    @draft ||= ApplicationDraft.find(params[:id])
>>>>>>> update user_application_draft_association table:app/controllers/drafts_controller.rb
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  private

  def draft_params
    params.require(:draft).permit(
      :notes,
      :pdf_draft,
      :category,
      user_ids: []
    )
  end

  def require_admin_or_access_to_friend
    return if current_user.admin_or_existing_relationship?(params[:friend_id])
    not_found
  end
end
