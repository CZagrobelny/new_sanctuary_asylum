class RegionalAdmin::FriendsController < RegionalAdminController
  def index
    @friends = current_region.friends.with_active_applications.with_assigned_lawyers.order('last_name asc')
  end

  def show
    @friend = Friend.find(params[:id])
  end
end
