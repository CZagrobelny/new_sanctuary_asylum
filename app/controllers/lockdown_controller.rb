class LockdownController < ApplicationController
    def new
    end

    def create
        email = lockdown_params[:email].downcase.strip
        user = User.find_by_email(email)
        
        if user
            if user.lockdown
                flash[:success] = "Lockdown succeeded."
            else
                flash[:error] = "Lockdown for #{email} failed."
            end
        else
            flash[:error] = "Lockdown for #{email} failed."
        end
        redirect_to lockdown_path
    end

    private

    def lockdown_params
        params.require(:lockdown).permit(
            :email
        )
    end
end
