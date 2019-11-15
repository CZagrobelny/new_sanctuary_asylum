class Admin::Friends::FriendNotesController < AdminController
  def new
    @friend_note = friend.friend_notes.new
    render_modal
  end
  
  def create
    @friend_note = friend.friend_notes.build(friend_note_params)
    if @friend_note.save
      render_success
    else
      render_modal
    end
  end

  def edit
    render_modal
  end

  private

  def friend_note
    @friend_note ||= FriendNote.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def detention_params
    params.require(:detention).permit(
      :friend_id,
      :user_id,
      :note
    )
  end

  def render_modal
    respond_to do |format|
      format.js { render file: 'admin/friends/friend_notes/modal', locals: { friend: friend, friend_note: friend_note } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render file: 'admin/friends/friend_notes/list', locals: { friend: friend } }
    end
  end

end