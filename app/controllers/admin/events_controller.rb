class Admin::EventsController < AdminController
  def index
    @events = Event.order('date desc').paginate(:page => params[:page])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = 'Event saved.'
      redirect_to admin_events_path
    else
      render 'edit'
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
       flash[:success] = 'Event saved.'
      redirect_to admin_events_path
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:success] = 'Event deleted.'
      redirect_to admin_events_path
    end
  end

  def attendance
    @event = Event.find(params[:id])
    @volunteer_attendance = @event.user_attendances
    @attending_volunteers = @event.users
    @friend_attendance = @event.friend_attendances
    @attending_friends = @event.friends
  end

  private
  def event_params
    params.require(:event).permit(
      :date, 
      :location_id, 
      :title, 
      :category
    )
  end
end