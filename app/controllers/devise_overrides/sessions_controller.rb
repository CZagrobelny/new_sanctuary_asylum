class DeviseOverrides::SessionsController < Devise::SessionsController

  def create
    valid_email = User.where email: params[:user][:email]
    if valid_email.empty?
      set_flash_message!(:alert, :invalid_email)
      redirect_to :root
    else
      super
    end
  end

end
