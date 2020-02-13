class Admin::CohortsController < AdminController
  before_action :require_admin_or_access_time_slot

  def index
    @cohorts = current_community.cohorts.order('start_date desc').paginate(page: params[:page])
  end

  def new
    @cohort = current_community.cohorts.new
  end

  def edit
    @cohort = current_community.cohorts.find(params[:id])
  end

  def create
    @cohort = current_community.cohorts.new(cohort_params)
    if @cohort.save
      flash[:success] = 'Cohort saved.'
      redirect_to community_admin_cohorts_path(current_community.slug)
    else
      render 'edit'
    end
  end

  def update
    @cohort = current_community.cohorts.find(params[:id])
    if @cohort.update(cohort_params)
      flash[:success] = 'Cohort saved.'
      redirect_to community_admin_cohorts_path(current_community.slug)
    else
      render 'edit'
    end
  end

  def destroy
    @cohort = current_community.cohorts.find(params[:id])
    return unless @cohort.destroy

    flash[:success] = 'Cohort deleted.'
    redirect_to community_admin_cohorts_path(current_community.slug)
  end

  def assignment
    @cohort = current_community.cohorts.find(params[:id])
    @friend_assignments = @cohort.friend_assignments
    @assigned_friends = @cohort.friends
    @events = Event.pro_se_clinics_at_dates([@cohort.start_date, @cohort.start_date + 1.week, @cohort.start_date + 2.weeks])
  end

  private

  def cohort_params
    params.require(:cohort).permit(
      :start_date,
      :color,
    )
  end
end
