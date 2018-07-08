class RegionalAdmin::RemoteLawyersController < AdminController
  before_action :set_lawyer, only: %i[edit update destroy]

  def index
    @remote_lawyers = User.remote_lawyers.order('last_name asc').paginate(page: params[:page])
  end

  def edit; end

  def update
    if @remote_lawyer.update(remote_lawyer_params)
      redirect_to regional_admin_remote_lawyers_path
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  def destroy
    return unless @remote_lawyer.destroy
    flash[:success] = 'Lawyer deleted.'
    redirect_to regional_admin_remote_lawyers_path
  end

  private

  def set_lawyer
    @remote_lawyer = User.find(params[:id])
  end

  def remote_lawyer_params
    params.require(:remote_lawyer).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :volunteer_type,
      :role,
      :signed_guidelines,
      :remote_clinic_lawyer
    )
  end
end
