class RegionalAdmin::ApplicationsController < RegionalAdminController
  def close
    if application.update_attributes(status: :closed)
      if friend.applications.where(status: %i[review_requested review_added approved]).empty?
        friend.user_friend_associations.where(remote: true).destroy_all
        flash[:success] = 'Application closed and assigned remote clinic lawyers removed. Friend has been removed from Active Applications dashboard.'
        redirect_to regional_admin_region_friends_path(region)
      else
        flash[:success] = 'Application closed.'
        redirect_to regional_admin_region_friend_path(region, friend)
      end
    else
      flash[:error] = 'There was an issue closing the application.'
      redirect_to regional_admin_region_friend_path(region, friend)
    end
  end

  private

  def application
    @application ||= Application.find(params[:application_id])
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  def region
    @region ||= Region.find(params[:region_id])
  end
end
