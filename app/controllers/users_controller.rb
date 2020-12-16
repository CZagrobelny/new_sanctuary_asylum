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

  def select2_options
    @users = current_community.users.confirmed.autocomplete_name(params[:q]).limit(10)
    results = { results: @users.map { |user| { id: user.id, text: user.name } } }

    respond_to do |format|
      format.json { render json: results }
    end
  end

  private

  def user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :pledge_signed,
      language_ids: [],
    )
  end

  def password_params
    compact_password_params = HashWithIndifferentAccess.new
    params.require(:user).permit(:password).each do |key, value|
      compact_password_params[key] = value.strip.empty? ? nil : value.strip
    end
    compact_password_params.compact
  end

  def require_account_owner
    not_found unless current_user.id.to_s == params[:id]
  end
end
