class RegionalAdmin::RemoteLawyersController < AdminController

  def index
    @remote_lawyers = User.remote_lawyers.order('last_name asc').paginate(:page => params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    return unless @user.destroy
    flash[:success] = 'Lawyer deleted.'
    redirect_to regional_admin_remote_lawyers_path
  end
end
