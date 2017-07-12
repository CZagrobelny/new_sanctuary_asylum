class Admin::ActivitiesController < AdminController

  def new
    activity = friend.activities.new
    respond_to do |format|
      format.js { render :file => 'admin/activities/modal', locals: {friend: friend, activity: activity}}
    end
  end

  def create
    activity = friend.activities.build(activity_params)
    if activity.save
      respond_to do |format|
        format.js { render :file => 'admin/activities/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'admin/activities/modal', locals: {friend: friend, activity: activity}}
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :file => 'admin/activities/modal', locals: {friend: friend, activity: activity}}
    end
  end

  def update
    if activity.update(activity_params)
      respond_to do |format|
        format.js { render :file => 'admin/activities/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'admin/activities/modal', locals: {friend: friend, activity: activity}}
      end
    end
  end

  def activity
    @activity ||= Activity.find(params[:id]) 
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  def destroy
    if activity.destroy
      respond_to do |format|
        format.js { render :file => 'admin/activities/list', locals: {friend: friend}}
      end
    end
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
end
