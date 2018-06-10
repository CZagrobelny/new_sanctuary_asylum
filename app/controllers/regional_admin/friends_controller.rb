class RegionalAdmin::FriendsController < RegionalAdminController
  def index
    @regional_friends = []
    current_user.regions.each do |region|
      @regional_friends << [region.name, region.friends.with_active_applications]
    end
  end

  def show
    @friend = Friend.find(params[:id])
  end
end
