class Admin::EventsController < AdminController
  def attendance
    @event = event
    @volunteer_attendance = event.user_attendances
    @attending_volunteers = event.users
  end

  def event
    @event = Event.find(params[:id])
  end
end