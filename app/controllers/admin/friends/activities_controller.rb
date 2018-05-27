class Admin::Friends::ActivitiesController < AdminController
  def new
    @activity = friend.activities.new(region_id: current_region.id)
    render_modal
  end

  def create
    @activity = friend.activities.build(activity_params)
    if @activity.save
      render_success
    else
      render_modal
    end
  end

  def edit
    render_modal
  end

  def update
    if activity.update(activity_params)
      render_success
    else
      render_modal
    end
  end

  def destroy
    if activity.destroy
      render_success
    end
  end

  def confirm
    if activity.update(confirmed: true)
      flash[:success] = 'Accompaniment confirmed.'
      redirect_to edit_admin_friend_path(friend, tab: '#activities')
    else
      flash.now[:error] = 'There was an issue confirming this accompaniment.'
      redirect_to edit_admin_friend_path(friend, tab: '#activities')
    end
  end

  def activity
    @activity ||= friend.activities.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  private

  def activity_params
    params.require(:activity).permit(
      :event,
      :location_id,
      :friend_id,
      :judge_id,
      :occur_at,
      :notes
    ).merge({ region_id: current_region.id })
  end

  def render_modal
    respond_to do |format|
      format.js { render :file => 'admin/friends/activities/modal', locals: { friend: friend, activity: activity } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render :file => 'admin/friends/activities/list', locals: { friend: friend } }
    end
  end
end
