class Admin::ActivitiesController < AdminController

  def index
    @current_month_activities = Activity.current_month
    @last_month_activities = Activity.last_month
  end

  def new
    
  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end

  def activity
    @activity ||= Activity.find(params[:id]) 
  end

  def destroy
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