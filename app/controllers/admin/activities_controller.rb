class Admin::ActivitiesController < AdminController

  def index
    @current_month_activities = Activity.current_month
    @last_month_activities = Activity.last_month
  end

  def new
    activity = friend.activities.new
    respond_to do |format|
      format.js { render :file => 'admin/activities/modal', locals: {activity: activity}}
    end
  end

  def create
    activity = friend.activities.build(activity_params)
    if activity.save
      render_success
    else
      respond_to do |format|
        format.js { render :file => 'admin/activities/modal', locals: {activity: activity}}
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :file => 'admin/activities/modal', locals: {activity: activity}}
    end
  end

  def update
    if activity.update(activity_params)
      render_success
    else
      respond_to do |format|
        format.js { render :file => 'admin/activities/modal', locals: {activity: activity}}
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
      render_destroy_success
    end
  end

  def referrer
    uri = URI(request.env['HTTP_REFERER'])
    if uri.path == "/admin/activities"
      'activities'
    else
      'friend_edit'
    end
  end

  def render_success
    referrer_uri = URI(request.env['HTTP_REFERER'])
    case referrer_uri.path
    when "/admin/activities"
      redirect_to admin_activities_path
    else
      respond_to do |format|
        format.js { render :file => 'admin/friends/activities/list', locals: {friend: friend}}
      end
    end
  end

  def render_destroy_success
    referrer_uri = URI(request.env['HTTP_REFERER'])
    case referrer_uri.path
    when "/admin/activities"
      redirect_to admin_activities_path
    else
      respond_to do |format|
        format.js { render :file => 'admin/friends/activities/list', locals: {friend: friend}}
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
