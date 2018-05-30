class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account_owner, only: [:edit, :update]

  def edit
    user
  end

  def update
    if user.update(user_params)
      redirect_to community_dashboard_path(current_community.slug)
    else
      render 'edit'
    end
  end

  private

  def user
    @user ||= current_community.users.find(params[:id])
  end

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