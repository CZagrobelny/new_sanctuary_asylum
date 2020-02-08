class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_account_owner, only: %i[edit update]

  def edit
    user
  end

  def update
    success_redirect_url = community_dashboard_url(current_community.slug)
    ActiveRecord::Base.transaction do
      user.update!(user_params)
      if password_params.present?
        if user.reset_password(password_params[:password], password_params[:password])
          flash[:success] = 'Password reset sucessfully, please log in to continue.'
          success_redirect_url = unauthenticated_root_url
        else
          user.errors.delete(:password)
          user.errors.add(:password, 'does not meet minimum password requirements (see below).')
          raise
        end
      end
    end
    redirect_to success_redirect_url
  rescue
    render 'edit'
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

  def password_params
    password_params = params.require(:user).permit(:password)

    password_params.each { |key, value|
      password_params[key] = value.strip.empty? ? nil : value.strip
    }.compact
  end

  def require_account_owner
    not_found unless current_user.id.to_s == params[:id]
  end
end
