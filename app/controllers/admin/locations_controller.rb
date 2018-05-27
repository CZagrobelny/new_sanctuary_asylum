class Admin::LocationsController < AdminController
  before_action :set_location, only: [:edit, :update]

  def index
    @locations = current_region.locations.order('created_at desc').paginate(:page => params[:page])
  end

  def new
    @location = current_region.locations.new
  end

  def edit
  end

  def create
    @location = current_region.locations.new(location_params)

    if @location.save
      redirect_to community_admin_locations_path(current_community)
    else
      flash.now[:error] = "Something went wrong :("
      render 'new'
    end
  end

  def update
    if @location.update(location_params)
      redirect_to community_admin_locations_path(current_community)
    else
      flash.now[:error] = "Something went wrong :("
      render 'edit'
    end
  end

  private

  def set_location
    @location = current_region.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name)
  end

end