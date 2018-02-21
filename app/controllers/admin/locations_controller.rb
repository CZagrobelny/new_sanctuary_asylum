class Admin::LocationsController < AdminController
  before_action :set_location, only: [:edit, :update]

  def index
    @locations = Location.order('created_at desc').paginate(:page => params[:page])
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @location = Location.new(location_params)
    
    if @location.save
      redirect_to admin_locations_path
    else
      flash.now[:error] = "Something went wrong :("
      render 'new'
    end
  end

  # FIXME: This should probably have error handling like create
  def update
    @location.update(location_params)
    redirect_to admin_locations_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end
  
end