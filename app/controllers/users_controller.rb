class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account_owner, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to community_dashboard_path(current_community)
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :volunteer_type,
      :pledge_signed
    )
  end

  def require_account_owner
    unless current_user.id.to_s == params[:id]
      not_found
    end
  end
end