class Admin::ActivitiesController < AdminController

  def index
     @activities = Activity.current_month
  end

  def last_month
    @activities = Activity.last_month
  end

  def new
    @activity = Activity.new
  end

  def edit
    @activity = activity
  end

  def create
    @activity = Activity.new(activity_params)
    if activity.save
      flash[:success] = 'Activity saved.'
      redirect_to admin_activities_path
    else
      flash.now[:error] = 'Activity not saved.'
      render :new
    end
  end

  def update
    if activity.update(activity_params)
      flash[:success] = 'Activity saved.'
      redirect_to admin_activities_path
    else
      flash.now[:error] = 'Activity not saved.'
      render :edit
    end
  end

  def activity
    @activity ||= Activity.find(params[:id]) 
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