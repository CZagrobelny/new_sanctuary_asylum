class Admin::FriendEventAttendancesController < AdminController
  before_action :require_primary_community

  def create
    friend_id_array = friend_event_attendance_params[:friend_id].reject(&:empty?)
    return unless friend_id_array.present?

    friend_id = friend_id_array[0].to_i
    @friend_event_attendance = FriendEventAttendance.new(event_id: event.id,
                                                         friend_id: friend_id)
    render_success if @friend_event_attendance.save
  end

  def destroy
    @friend_event_attendance = FriendEventAttendance.find(params[:id])
    render_success if @friend_event_attendance.destroy
  end

  private

  def event
    Event.find(params[:event_id])
  end

  def render_success
    respond_to do |format|
      format.js do
        render template: 'admin/events/friend_attendance',
               locals: { event: event,
                         friend_attendance: event.friend_attendances,
                         attending_friends: event.friends }
      end
    end
  end

  def friend_event_attendance_params
    params.require(:friend_event_attendance).permit(
      friend_id: []
    )
  end
end
