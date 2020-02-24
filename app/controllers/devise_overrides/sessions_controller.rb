class DeviseOverrides::SessionsController < Devise::SessionsController

  def create
    email_address = params[:user][:email].try(:downcase)
    if User.find_by_email(email_address)
      super
    else
      set_flash_message!(:alert, :invalid_email)
      redirect_to :root
    end
  end
end
