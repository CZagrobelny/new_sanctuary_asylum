class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_login
  def edit
    @user = User.find(params[:id])
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
    permitted_user_params = [:first_name, :last_name, :email, :phone]
    if current_user.admin?
      permitted_user_params << :role
    end
    permitted_user_params
  end
end