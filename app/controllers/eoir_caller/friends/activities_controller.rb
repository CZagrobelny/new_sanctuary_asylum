class EoirCaller::Friends::ActivitiesController < EoirCallerController

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
    render_success if activity.destroy
  end

  private

  def activity
    @activity ||= friend.activities.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def activity_params
    params.require(:activity).permit(
      :activity_type_id,
      :location_id,
      :friend_id,
      :judge_id,
      :occur_at,
      :control_date,
      :occur_at_tbd,
      :notes,
    ).merge(region_id: current_region.id, last_edited_by: current_user.id)
  end

  def render_modal
    respond_to do |format|
      format.js { render template: 'eoir_caller/friends/activities/modal', locals: { friend: friend, activity: activity } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render template: 'eoir_caller/friends/activities/list', locals: { friend: friend } }
    end
  end
end