class InvitationsController < Devise::InvitationsController
  before_action :authenticate_user!
  before_action :require_admin, only: [:new, :create]
  before_filter :update_sanitized_params, only: :update

  protected

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone, :password, :password_confirmation, :invitation_token, :volunteer_type])
  end
end