class Admin::FriendEventAttendancesController < AdminController
  def create
    friend_id_array = friend_event_attendance_params[:friend_id].reject { |f| f.empty? }
    friend_id = friend_id_array[0].to_i
    @friend_event_attendance = FriendEventAttendance.new(event_id: event.id, friend_id: friend_id)
    if @friend_event_attendance.save
      render_success
    end
  end

  def destroy
    @friend_event_attendance = FriendEventAttendance.find(params[:id])
    if @friend_event_attendance.destroy
      render_success
    end
  end

  def event
    Event.find(params[:event_id])
  end

  def render_success
    respond_to do |format|
      format.js { render :file => 'admin/events/friend_attendance', locals: {event: event, friend_attendance: event.friend_attendances, attending_friends: event.friends} }
    end
  end

  def friend_event_attendance_params
    params.require(:friend_event_attendance).permit(
      :friend_id => []
    )
  end
end