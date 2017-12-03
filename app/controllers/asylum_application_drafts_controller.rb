class AsylumApplicationDraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_access_to_friend
  before_action :require_admin, only: [:destroy]

  def new
    @asylum_application_draft = AsylumApplicationDraft.new
    @friend = friend
  end

  def create
    @asylum_application_draft = friend.asylum_application_drafts.new(asylum_application_draft_params)
    if @asylum_application_draft.save
      flash[:success] = 'Asylum application draft saved.'
      render_success
    else
      flash.now[:error] = 'Asylum application draft not saved.'
      render :new
    end
  end

  def edit
    @asylum_application_draft = asylum_application_draft
    @friend = friend
  end

  def update
    if asylum_application_draft.update(asylum_application_draft_params)
      flash[:success] = 'Asylum application draft saved.'
      render_success
    else
      # TODO: Figure out why we needed to redefine our @friend variable in
      # this half of the conditional, w/o it, @friend = nil even though
      # params[:friend_id] is == to friend_id.
      @friend = friend
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def index
    @friend = friend
  end

  def destroy
    if asylum_application_draft.destroy
      flash[:success] = 'Asylum application draft destroyed.'
      redirect_to edit_admin_friend_path(friend, tab: '#asylum')
    else
      flash[:error] = 'Error destroying asylum application draft.'
      redirect_to friend_asylum_application_drafts_path(friend)
    end
  end

  def render_success
    if current_user.admin?
      redirect_to edit_admin_friend_path(friend, tab: '#asylum')
    else
      redirect_to friend_path(friend, tab: '#asylum')
    end
  end

  def asylum_application_draft
    @asylum_application_draft ||= AsylumApplicationDraft.find(params[:id])
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  private
  def asylum_application_draft_params
    params.require(:asylum_application_draft).permit(
      :notes,
      :pdf_draft,
      :user_ids => []
    )
  end

  def require_admin_or_access_to_friend
    unless current_user.admin? || UserFriendAssociation.where(friend_id: params[:friend_id], user_id: current_user.id).present?
      not_found
    end
  end
end
