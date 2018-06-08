class RegionalAdmin::LawyersController < AdminController

  def index
    @lawyers = User.lawyers.order('last_name asc').paginate(:page => params[:page])
  end
end
