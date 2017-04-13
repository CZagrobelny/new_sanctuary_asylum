class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_account_owner, only: [:edit, :update]
  before_action :require_admin, only: :index
  
  def index
    if params[:query].present?
      query = '%' + params[:query].downcase + '%'
      @users = User.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ?', query, query, query)
                    .order('last_name asc')
                    .paginate(:page => params[:page])
    else
      @users = User.all.order('last_name asc').paginate(:page => params[:page])
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(
      permitted_user_params
    )
  end

  def permitted_user_params
    permitted_user_params = [:first_name, :last_name, :email, :phone, :volunteer_type]
    if current_user.admin?
      permitted_user_params << :role
    end
    permitted_user_params
  end

  def require_admin_or_account_owner
    unless current_user.admin? || current_user.id.to_s == params[:id]
      not_found
    end
  end
end