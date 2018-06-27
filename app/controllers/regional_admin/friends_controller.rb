class RegionalAdmin::FriendsController < RegionalAdminController
  before_action :find_friend, only: [:show, :assign_friendship]

  def index
    @friends = current_region.friends.with_active_applications.with_assigned_lawyers.order('last_name asc')
  end

  def show; end

  def assign_friendship
    if lawyer = User.find_by(id: params[:user][:id])
      @friend.user_friend_associations.create(user_id: lawyer.id, remote: true)
      flash[:notice] = "An invitation email has been sent to #{lawyer.email}."
      redirect_to regional_admin_region_friend_path(@friend)
    end
  rescue
    flash.now[:error] = "Something went wrong. Please try again."
    redirect_to regional_admin_region_friend_path(@friend)
  end

  private def find_friend
    @friend = Friend.find_by(id: params[:id])
  end
end
