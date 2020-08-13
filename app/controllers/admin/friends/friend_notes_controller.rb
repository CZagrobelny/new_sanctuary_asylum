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

  def update
    if friend_note.update(friend_note_params)
      render_success
    else
      render_modal
    end
  end

  def destroy
    render_success if friend_note.destroy
  end

  private

  def friend_note
    @friend_note ||= friend.friend_notes.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def friend_note_params
    params.require(:friend_note).permit(
      :friend_id,
      :note
    ).merge(user_id: current_user.id)
  end

  def render_modal
    respond_to do |format|
      format.js { render template: 'admin/friends/friend_notes/modal', locals: { friend: friend, friend_note: friend_note } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render template: 'admin/friends/friend_notes/list', locals: { friend: friend } }
    end
  end

end