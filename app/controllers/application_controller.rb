class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def require_admin
    not_found unless current_user.admin?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_admin_or_access_to_friend
    unless current_user.admin? || UserFriendAssociation.where(friend_id: params[:friend_id], user_id: current_user.id).present?
      not_found
    end
  end
end
