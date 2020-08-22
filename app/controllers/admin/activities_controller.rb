class Admin::ActivitiesController < AdminController
  before_action :require_primary_community

  def index
    @activities = current_region.activities
                                .non_accompaniment_eligible
                                .includes(:friend, :location)
  end

  def accompaniments
    @activities = current_region.activities
                                .accompaniment_eligible
                                .includes(:accompaniments, :users, :accompaniment_reports, :friend, :location)
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
      flash[:success] = 'Activity/Accompaniment saved.'
      redirect_to community_admin_activities_path(current_community.slug, start_date: start_date)
    else
      flash.now[:error] = 'Activity/Accompaniment not saved.'
      render :new
    end
  end

  def update
    if activity.update(activity_params)
      flash[:success] = 'Activity/Accompaniment saved.'
      if activity.accompaniment_eligible?
        redirect_to accompaniments_community_admin_activities_path(current_community.slug, start_date: start_date)
      else
        redirect_to community_admin_activities_path(current_community.slug, start_date: start_date)
      end
    else
      flash.now[:error] = 'Activity/Accompaniment not saved.'
      render :edit
    end
  end

  def confirm
    if activity.update(confirmed: true)
      flash[:success] = 'Accompaniment confirmed.'
    else
      flash.now[:error] = 'There was an issue confirming this accompaniment.'
    end
    redirect_to accompaniments_community_admin_activities_path(start_date: start_date)
  end

  def unconfirm
    if activity.update(confirmed: false)
      flash[:success] = 'Accompaniment confirmation removed.'
    else
      flash.now[:error] = 'There was an issue unconfirming this accompaniment.'
    end
    redirect_to accompaniments_community_admin_activities_path(start_date: start_date)
  end

  def select2_regional_friends
    @friends = current_region.friends.autocomplete_name(params[:q])
    results = { results: @friends.map { |friend| { id: friend.id, text: friend.name } } }

    respond_to do |format|
      format.json { render json: results }
    end
  end

  private

  def activity
    @activity ||= current_region.activities.find(params[:id])
  end

  def start_date
    date ||= if activity.occur_at?
      activity.occur_at
    else
      Time.now
    end
    @start_date ||= if activity.accompaniment_eligible?
      date.beginning_of_week.to_date
    else
      date.beginning_of_month.to_date
    end
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
      :public_notes
    ).merge(last_edited_by: current_user.id)
  end
end
