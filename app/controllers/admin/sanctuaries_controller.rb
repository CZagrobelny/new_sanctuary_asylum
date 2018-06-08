class Admin::SanctuariesController < AdminController
  before_action :set_sanctuary, only: %i[edit update]

  def index
    @sanctuaries = current_community.sanctuaries.order('name ASC').paginate(page: params[:page])
  end

  def new
    @sanctuary = current_community.sanctuaries.new
  end

  def create
    @sanctuary = current_community.sanctuaries.new(sanctuary_params)

    if @sanctuary.save
      redirect_to community_admin_sanctuaries_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'new'
    end
  end

  def edit
    # Render
  end

  def update
    if @sanctuary.update(sanctuary_params)
      redirect_to community_admin_sanctuaries_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  private

  def set_sanctuary
    @sanctuary = current_community.sanctuaries.find(params[:id])
  end

  def sanctuary_params
    params.require(:sanctuary).permit(:name,
                                      :address,
                                      :city,
                                      :state,
                                      :zip_code,
                                      :leader_name,
                                      :leader_phone_number,
                                      :leader_email)
  end
end
