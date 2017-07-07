class Admin::AsylumApplicationDraftsController < AdminController
  def create
    asylum_application_draft = AsylumApplicationDraft.new(asylum_application_draft_params)
    if asylum_application_draft.save
      respond_to do |format|
        format.js { render :file => 'asylum_application_drafts/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'asylum_application_drafts/modal', locals: {friend: friend, family_member_constructor: family_member_constructor}}
      end
    end
  end

  def friend
    @friend ||= Friend.find(asylum_application_draft_params[:friend_id])
  end

  private
  def asylum_application_draft_params
    params.require(:asylum_application_draft).permit(
      :friend_id, 
      :notes,
      :user_ids => []
    )
  end
end