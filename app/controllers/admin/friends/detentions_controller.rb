class Admin::Friends::DetentionsController < AdminController
  def new
    @detention = friend.detentions.new
    render_modal
  end

  def create
    @detention = friend.detentions.build(detention_params)
    if @detention.save
      render_success
    else
      render_modal
    end
  end

  def edit
    render_modal
  end

  def update
    if detention.update(detention_params)
      render_success
    else
      render_modal
    end
  end

  def destroy
    render_success if detention.destroy
  end

  private

  def detention
    @detention ||= Detention.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def detention_params
    params.require(:detention).permit(
      :friend_id,
      :location_id,
      :date_detained,
      :date_released,
      :notes,
      :case_status,
      :other_case_status
    )
  end

  def render_modal
    respond_to do |format|
      format.js { render template: 'admin/friends/detentions/modal', locals: { friend: friend, detention: detention } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render template: 'admin/friends/detentions/list', locals: { friend: friend } }
    end
  end
end
