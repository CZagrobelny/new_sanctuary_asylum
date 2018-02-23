class SessionsController < Devise::SessionsController
  before_action :locked_account_verification, only: :create

  private

  def locked_account_verification
    user = User.find_by_email(sign_in_params['email'])

    user.valid_for_authentication? { user.valid_password?(sign_in_params[:password]) }

    if user.access_locked?
      flash[:alert] = "Your account is locked."
      redirect_to new_user_unlock_url
    else
      if user.failed_attempts >= 5
        remaining_attempts = user.class.maximum_attempts - user.failed_attempts
        flash[:alert] = "You have #{remaining_attempts} more #{'attempt'.pluralize(remaining_attempts)} before your account is locked."
      elsif user.failed_attempts == user.class.maximum_attempts - 1
        flash[:alert] = "You have one more attempt before your account is locked."
      else
        flash[:alert] = "Invalid email or password."
      end
      redirect_to root_url
    end
  end
end