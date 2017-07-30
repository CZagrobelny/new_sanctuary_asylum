class Admin::UserEventAttendancesController < AdminController
  def create
    @user_event_attendance = UserEventAttendance.new(event_id: event.id, user_id: user_event_attendance_params[:user_id][0].to_i)
    if @user_event_attendance.save
      render_success
    end
  end

  def destroy
    @user_event_attendance = UserEventAttendance.find(params[:id])
    if @user_event_attendance.destroy
      render_success
    end
  end

  def event
    Event.find(params[:event_id])
  end

  def render_success
    respond_to do |format|
      format.js { render :file => 'admin/events/volunteer_attendance', locals: {event: event, volunteer_attendance: event.user_attendances, attending_volunteers: event.users} }
    end
  end

  def user_event_attendance_params
    params.require(:user_event_attendance).permit(
      :user_id => []
    )
  end
end