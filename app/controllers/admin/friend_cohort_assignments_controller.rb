class Admin::FriendCohortAssignmentsController < AdminController
  def create
    friend_id_array = friend_cohort_assignment_params[:friend_id].reject(&:empty?)
    return unless friend_id_array.present?

    friend_id = friend_id_array[0].to_i
    @friend_cohort_assignment = FriendCohortAssignment.new(cohort_id: cohort.id,
                                                         friend_id: friend_id)
    render_success if @friend_cohort_assignment.save
  end

  def update
    @friend_cohort_assignment = FriendCohortAssignment.find(params[:id])
    @friend_cohort_assignment.update(friend_cohort_assignment_params)
    redirect_to assignment_community_admin_cohort_path(current_community.slug, cohort)
  end

  def destroy
    @friend_cohort_assignment = FriendCohortAssignment.find(params[:id])
    render_success if @friend_cohort_assignment.destroy
  end

  private

  def cohort
    Cohort.find(params[:cohort_id])
  end

  def render_success
    @events = Event.pro_se_clinics_at_dates([cohort.start_date, cohort.start_date + 1.week, cohort.start_date + 2.weeks])
    respond_to do |format|
      format.js do
        render template: 'admin/cohorts/friend_assignment',
               locals: { cohort: cohort,
                         friend_assignments: cohort.friend_assignments,
                         assigned_friends: cohort.friends }
      end
    end
  end

  def friend_cohort_assignment_params
    params.require(:friend_cohort_assignment).permit(
      :confirmed,
      friend_id: []
    )
  end
end
