class InvitationsController < Devise::InvitationsController
  before_action :authenticate_user!
  before_action :require_admin_or_access_time_slot, only: %i[new create]
  before_action :require_access_to_community, only: %i[new create]
  before_action :update_sanitized_params, only: :update
  before_action :set_invitee_role, only: :create
  before_action :allow_devise_params, only: :create

  ## This is a devise invitable method that I needed to overwrite, unfortunately
  ## because of the way they implemented the 'redirect' on success (they used respond_with)
  ## Original method: https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L18
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty? && resource.update_columns(role: @role)

    yield resource if block_given?

    if resource_invited
      flash[:notice] = "An invitation email has been sent to #{resource.email}." if resource.invitation_sent_at
    else
      flash[:notice] = 'An account has already been created with this email.'
    end
    redirect_to new_user_community_invitation_path(resource.community.slug)
  end

  protected

  def after_accept_path_for(_current_user)
    community_dashboard_path(current_community)
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation) do |user|
      user.permit(:first_name,
                  :last_name,
                  :phone,
                  :password,
                  :password_confirmation,
                  :invitation_token,
                  :pledge_signed,
                  language_ids: [])
    end
  end

  def allow_devise_params
    devise_parameter_sanitizer.permit(:invite, keys: %i[community_id])
  end

  def set_invitee_role
    if params['remote_clinic_lawyer'] == 'true'
      @role = 'remote_clinic_lawyer'
    else
      @role = 'volunteer'
    end
  end
end
