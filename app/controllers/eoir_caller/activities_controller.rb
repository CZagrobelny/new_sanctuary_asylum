class EoirCaller::ActivitiesController < EoirCallerController
  def index
    @activities = current_region.activities
      .accompaniment_eligible
      .where('occur_at > ?', Date.today.beginning_of_week)
      .where('occur_at < ?', 3.weeks.from_now.end_of_week)
      .includes(:users, :friend, :location)
  end
end
