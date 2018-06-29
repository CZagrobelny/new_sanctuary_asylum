class RemoteClinic::Lawyers::FriendsController < UsersController
  before_action :authenticate_user!
  before_action :require_access_to_friend, only: [:show]

  def index
    @friends = current_user.remote_clinic_friends.with_active_applications
  end

  def show
    @friend = Friend.find_by(id: params[:id])
  end

  private def require_access_to_friend
    friend = Friend.find_by(id: params[:id])

    return not_found unless current_user.existing_relationship?(friend.id)
  end
end
