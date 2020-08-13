require 'devise_overrides/user_with_password'
class DeviseOverrides::PasswordExpiredController < Devise::PasswordExpiredController
  # A slight customization of how devise_security_extension was doing things
  def update
    resource.extend(DeviseOverrides::UserWithPassword)
    if resource.update_with_password(resource_params, skip_password: true)
      warden.session(scope)['password_expired'] = false
      set_flash_message :notice, :updated
      bypass_sign_in resource, scope: scope
      redirect_to stored_location_for(scope) || :root
    else
      clean_up_passwords(resource)
      respond_with(resource, action: :show)
    end
  end
end
