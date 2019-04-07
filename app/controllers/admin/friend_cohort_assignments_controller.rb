class Admin::FriendCohortAssignmentsController < AdminController

  def create
    friend_id_array = friend_cohort_assignment_params[:friend_id].reject(&:empty?)
    return unless friend_id_array.present?

    friend_id = friend_id_array[0].to_i
    @friend_cohort_assignment = FriendCohortAssignment.new(cohort_id: cohort.id,
                                                         friend_id: friend_id)
    render_success if @friend_cohort_assignment.save
  end

  def destroy
    @friend_cohort_assignment = FriendCohortAssignment.find(params[:id])
    render_success if @friend_cohort_assignment.destroy
  end

  def cohort
    Cohort.find(params[:cohort_id])
  end

  def render_success
    respond_to do |format|
      format.js do
        render file: 'admin/cohorts/friend_assignment',
               locals: { cohort: cohort,
                         friend_assignments: cohort.friend_assignments,
                         assigned_friends: cohort.friends }
      end
    end
  end

  def friend_cohort_assignment_params
    params.require(:friend_cohort_assignment).permit(
      friend_id: []
    )
  end
end
