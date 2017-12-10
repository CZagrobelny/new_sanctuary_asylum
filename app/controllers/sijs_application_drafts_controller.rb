class SijsApplicationDraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_access_to_friend
  before_action :require_admin, only: [:destroy]

  def new
    @sijs_application_draft = SijsApplicationDraft.new
    @friend = friend
  end

  def create
    @sijs_application_draft = friend.sijs_application_drafts.new(sijs_application_draft_params)
    if @sijs_application_draft.save
      flash[:success] = 'SIJS application draft saved.'
      render_success
    else
      flash.now[:error] = 'SIJS application draft not saved.'
      render :new
    end
  end

  def edit
    @sijs_application_draft = sijs_application_draft
    @friend = friend
  end

  def update
    if sijs_application_draft.update(sijs_application_draft_params)
      flash[:success] = 'SIJS application draft saved.'
      render_success
    else
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def index
    @friend = friend
  end

  def destroy
    if sijs_application_draft.destroy
      flash[:success] = 'SIJS application draft destroyed.'
      redirect_to friend_path(friend, tab: '#sijs')
    else
      flash[:error] = 'Error destroying SIJS application draft.'
      redirect_to friend_asylum_application_drafts_path(friend)
    end
  end

  def render_success
    if current_user.admin?
      redirect_to edit_admin_friend_path(friend, tab: '#sijs')
    else
      redirect_to friend_path(friend, tab: '#sijs')
    end
  end

  def sijs_application_draft
    @sijs_application_draft ||= SijsApplicationDraft.find(params[:id])
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  private
  def sijs_application_draft_params
    params.require(:sijs_application_draft).permit(
      :notes,
      :pdf_draft,
      :user_ids => []
    )
  end
end
