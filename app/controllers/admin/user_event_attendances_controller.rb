class Admin::UserEventAttendancesController < AdminController
  before_action :require_primary_community

  def create
    user_id_array = user_event_attendance_params[:user_id].reject(&:empty?)
    return unless user_id_array.present?

    user_id = user_id_array[0].to_i
    @user_event_attendance = UserEventAttendance.new(event_id: event.id,
                                                     user_id: user_id)
    render_success if @user_event_attendance.save
  end

  def destroy
    @user_event_attendance = UserEventAttendance.find(params[:id])
    render_success if @user_event_attendance.destroy
  end

  def select2_options
    already_assigned = event.users.pluck(:id)
    @users = current_community.users.where.not(id: already_assigned).autocomplete_name(params[:q])
    results = { results: @users.map { |user| { id: user.id, text: user.name } } }

    respond_to do |format|
      format.json { render json: results }
    end
  end

  private

  def event
    Event.find(params[:event_id])
  end

  def render_success
    respond_to do |format|
      format.js do
        render template: 'admin/events/volunteer_attendance',
               locals: { event: event,
                         volunteer_attendance: event.user_attendances,
                         attending_volunteers: event.users }
      end
    end
  end

  def user_event_attendance_params
    params.require(:user_event_attendance).permit(
      user_id: []
    )
  end
end
