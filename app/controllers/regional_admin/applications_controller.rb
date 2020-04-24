class RegionalAdmin::ApplicationsController < RegionalAdminController
  def close
    ActiveRecord::Base.transaction do
      application.update!(status: 'closed')
      RemoteReviewAction.create!(
        action: 'closed',
        user_id: current_user.id,
        friend_id: friend.id,
        community_id: friend.community_id,
        region_id: region.id,
        application_id: application.id,
      )
    end
    if friend.applications.where(status: %i[review_requested review_added approved]).empty?
      friend.user_friend_associations.where(remote: true).destroy_all
      flash[:success] = 'Application closed and assigned remote clinic lawyers removed.'
      redirect_to regional_admin_region_remote_review_actions_path(region)
    else
      flash[:success] = 'Application closed.'
      redirect_to regional_admin_region_friend_path(region, friend)
    end
  rescue
    flash[:error] = 'There was an issue closing the application.'
    redirect_to regional_admin_region_friend_path(region, friend)
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
