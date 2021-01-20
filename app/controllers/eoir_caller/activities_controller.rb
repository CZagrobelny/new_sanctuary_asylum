class EoirCaller::ActivitiesController < EoirCallerController
  def index
    @activities = current_region.activities
      .accompaniment_eligible
      .where('occur_at > ?', Date.today.beginning_of_week)
      .where('occur_at < ?', 4.weeks.from_now.end_of_week)
      .includes(:users, :friend, :location)
  end

  def confirm
    if activity.update(confirmed: true)
      flash[:success] = 'Accompaniment confirmed.'
    else
      flash.now[:error] = 'There was an issue confirming this accompaniment.'
    end
    redirect_to community_eoir_caller_activities_path(current_community, start_date: start_date)
  end

  def unconfirm
    if activity.update(confirmed: false)
      flash[:success] = 'Accompaniment confirmation removed.'
    else
      flash.now[:error] = 'There was an issue unconfirming this accompaniment.'
    end
    redirect_to community_eoir_caller_activities_path(current_community, start_date: start_date)
  end

  private
  def activity
    @activity ||= current_region.activities.find(params[:id])
  end

  def start_date
    @start_date ||= if activity.occur_at?
      activity.occur_at.beginning_of_week.to_date
    else
      Time.now.beginning_of_week.to_date
    end
  end
end
