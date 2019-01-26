class Admin::EventsController < AdminController
  before_action :require_primary_community

  def index
    @events = current_community.events.order('date desc').paginate(page: params[:page])
  end

  def new
    @event = current_community.events.new
  end

  def edit
    @event = current_community.events.find(params[:id])
  end

  def create
    @event = current_community.events.new(event_params)
    if @event.save
      flash[:success] = 'Event saved.'
      redirect_to community_admin_events_path(current_community.slug)
    else
      render 'edit'
    end
  end

  def update
    @event = current_community.events.find(params[:id])
    if @event.update(event_params)
      flash[:success] = 'Event saved.'
      redirect_to community_admin_events_path(current_community.slug)
    else
      render 'edit'
    end
  end

  def destroy
    @event = current_community.events.find(params[:id])
    return unless @event.destroy

    flash[:success] = 'Event deleted.'
    redirect_to community_admin_events_path(current_community.slug)
  end

  def attendance
    @event = current_community.events.find(params[:id])
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
