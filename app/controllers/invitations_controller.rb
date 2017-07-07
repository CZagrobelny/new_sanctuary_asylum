class InvitationsController < Devise::InvitationsController
  before_action :authenticate_user!
  before_action :require_admin, only: [:new, :create]
  before_action :update_sanitized_params, only: :update

  protected

  def after_invite_path_for(current_user)
    new_user_invitation_path
  end

  def after_accept_path_for(current_user)
  	dashboard_path
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone, :password, :password_confirmation, :invitation_token, :volunteer_type])
  end
end
