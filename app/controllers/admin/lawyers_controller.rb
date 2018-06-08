class Admin::LawyersController < AdminController
  before_action :set_lawyer, only: %i[edit update]

  def index
    @lawyers = current_region.lawyers.order('organization asc').paginate(page: params[:page])
  end

  def new
    @lawyer = current_region.lawyers.new
  end

  def edit; end

  def create
    @lawyer = current_region.lawyers.new(lawyer_params)

    if @lawyer.save
      redirect_to community_admin_lawyers_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'new'
    end
  end

  def update
    if @lawyer.update(lawyer_params)
      redirect_to community_admin_lawyers_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  private

  def set_lawyer
    @lawyer = current_region.lawyers.find(params[:id])
  end

  def lawyer_params
    params.require(:lawyer).permit(:first_name, :last_name, :email, :phone_number, :organization)
  end
end
