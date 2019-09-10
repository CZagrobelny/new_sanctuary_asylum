class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_account_owner, only: %i[edit update]

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
      :pledge_signed,
      :remote_clinic_lawyer,
      language_ids: [],
    )
  end

  def require_account_owner
    not_found unless current_user.id.to_s == params[:id]
  end
end
