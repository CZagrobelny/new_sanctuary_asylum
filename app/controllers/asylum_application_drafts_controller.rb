class AsylumApplicationDraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_friend
  before_action :require_admin, only: [:destroy]

  def new
    @asylum_application_draft = AsylumApplicationDraft.new
    @friend = friend
  end

  def create
    @asylum_application_draft = AsylumApplicationDraft.new(asylum_application_draft_params)
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
    if @asylum_application_draft.update(asylum_application_draft_params)
      flash[:success] = 'Asylum application draft saved.'
      render_success
    else
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end 
  end

  def render_success
    if current_user.admin?
      redirect_to edit_admin_friend_path(@friend, tab: '#asylum')
    else
      redirect_to friend_path(@friend)
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
    unless current_user.admin? || UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?
      not_found
    end
  end
end