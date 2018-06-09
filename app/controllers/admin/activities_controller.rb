class Admin::ActivitiesController < AdminController
  before_action :require_primary_community

  def index
    @all = current_region.activities.where(event: Activity::NON_ACCOMPANIMENT_ELIGIBLE_EVENTS)
    @activities = current_region.activities
                                .current_month(events: Activity::NON_ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                               region: current_region)
  end

  def last_month
    @activities = current_region.activities
                                .last_month(events: Activity::NON_ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                            region: current_region)
  end

  def accompaniments
    @all = current_region.activities.where(event: Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS)
    @activities = current_region.activities
                                .current_month(events: Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                               region: current_region)
  end

  def last_month_accompaniments
    @activities = current_region.activities
                                .last_month(events: Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                            region: current_region)
  end

  def new
    @activity = current_region.activities.new
  end

  def edit
    @activity = activity
  end

  def create
    @activity = current_region.activities.new(activity_params)
    if activity.save
      flash[:success] = 'Activity saved.'
      redirect_to community_admin_activities_path(current_community.slug)
    else
      flash.now[:error] = 'Activity not saved.'
      render :new
    end
  end

  def update
    if activity.update(activity_params)
      flash[:success] = 'Activity saved.'
      redirect_to community_admin_activities_path(current_community.slug)
    else
      flash.now[:error] = 'Activity not saved.'
      render :edit
    end
  end

  def confirm
    if activity.update(confirmed: true)
      flash[:success] = 'Accompaniment confirmed.'
    else
      flash.now[:error] = 'There was an issue confirming this accompaniment.'
    end
    redirect_to accompaniments_community_admin_activities_path
  end

  def activity
    @activity ||= current_region.activities.find(params[:id])
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
