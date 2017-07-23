class AsylumApplicationDraftsController < ApplicationController

  def new
    @asylum_application_draft = friend.asylum_application_drafts.new
    respond_to do |format|
      format.js { render :file => 'friends/asylum_application_drafts/modal', locals: {friend: friend, asylum_application_draft: asylum_application_draft}}
    end
  end

  def create
    asylum_application_draft = friend.asylum_application_drafts.build(asylum_application_draft_params)
    if asylum_application_draft.save
      respond_to do |format|
        format.js { render :file => 'friends/asylum_application_drafts/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'friends/asylum_application_drafts/modal', locals: {friend: friend, asylum_application_draft: asylum_application_draft}}
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :file => 'friends/asylum_application_drafts/modal', locals: {friend: friend, asylum_application_draft: asylum_application_draft}}
    end
  end

  def update
    if asylum_application_draft.update(asylum_application_draft_params)
      respond_to do |format|
        format.js { render :file => 'friends/asylum_application_drafts/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'friends/asylum_application_drafts/modal', locals: {friend: friend, asylum_application_draft: asylum_application_draft}}
      end
    end
  end

  def asylum_application_draft
    @asylum_application_draft ||= AsylumApplicationDraft.find(params[:id]) 
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  def destroy
    if asylum_application_draft.destroy
      respond_to do |format|
        format.js { render :file => 'friends/asylum_application_drafts/list', locals: {friend: friend}}
      end
    end
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