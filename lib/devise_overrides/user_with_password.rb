module DeviseOverrides::UserWithPassword
  # Taken from devise_security_extension but customized for us
  def update_with_password(params, *options)
    # Options is an Array containing a Hash
    if options.first.delete(:skip_password)
      # This is all customized for our needs
      if params[:password].present? && params[:password_confirmation].present?
        # We're skipping password so it shouldn't need to be deleted
        update(params)
      else
        assign_attributes(params)
        valid?
        false
      end
    else
      # Runs the code in Devise::Models::DatabaseAuthenticatable
      super
    end
  end
end
