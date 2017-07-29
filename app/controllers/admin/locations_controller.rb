class Admin::LocationsController < AdminController
  before_action :set_location, only: [:edit, :destroy, :update]

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
      flash[:error] = "Something went wrong :("
      render 'new'
    end
  end

  def update
    @location.update(location_params)
    redirect_to admin_locations_path
  end

  def destroy
    if @location.destroy
      flash[:success] = 'Location successfully removed' 
    else
      flash[:error] = 'Something went wrong :( the location could not be removed' 
    end

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