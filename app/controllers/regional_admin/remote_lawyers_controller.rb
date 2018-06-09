class RegionalAdmin::RemoteLawyersController < AdminController

  def index
    @remote_lawyers = User.remote_lawyers.order('last_name asc').paginate(:page => params[:page])
  end
end
