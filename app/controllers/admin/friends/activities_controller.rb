class Admin::Friends::ActivitiesController < AdminController
  def new
    @activity = friend.activities.new
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

  def activity
    @activity ||= Activity.find(params[:id]) 
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
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
    )
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
