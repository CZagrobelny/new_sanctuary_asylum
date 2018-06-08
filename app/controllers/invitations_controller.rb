class InvitationsController < Devise::InvitationsController
  before_action :authenticate_user!
  before_action :require_admin, only: [:new, :create]
  before_action :require_access_to_community, only: [:new, :create]
  before_action :update_sanitized_params, only: :update
  before_action :allow_community_id, only: :create

  ## This is a devise invitable method that I needed to overwrite, unfortunately
  ## because of the way they implemented the 'redirect' on success (they used respond_with)
  ## Original method: https://github.com/scambra/devise_invitable/blob/master/app/controllers/devise/invitations_controller.rb#L18
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if self.resource.invitation_sent_at
        flash[:notice] = "An invitation email has been sent to #{self.resource.email}."
      end
      redirect_to new_user_community_invitation_path(resource.community.slug)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  protected

  def after_accept_path_for(current_user)
  	community_dashboard_path(current_community)
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone, :password, :password_confirmation, :invitation_token, :volunteer_type, :pledge_signed])
  end

  def allow_community_id
    devise_parameter_sanitizer.permit(:invite, keys: [:community_id])
  end
end
