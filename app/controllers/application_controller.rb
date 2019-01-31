class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  helper_method :current_community, :current_region

  def current_community
    return @current_community if @current_community
    return Community.find_by_slug(params[:community_slug]) if params[:community_slug]

    Community.find(current_user.community_id)
  end

  def current_region
    return @current_region if @current_region
    return Region.find(params[:region_id]) if params[:region_id]

    current_community.region
  end

  def require_admin
    not_found unless current_user.admin?
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def require_access_to_community
    not_found unless current_user.can_access_community?(current_community)
  end

  def require_admin_or_access_to_friend
    return if current_user.admin_or_existing_relationship?(params[:friend_id])

    not_found
  end

  def require_primary_community
    not_found unless current_community.primary?
  end

  def require_regional_admin_or_remote_lawyer_with_access_to_friend
    not_found unless current_user.regional_admin? || current_user.existing_remote_relationship?(params[:friend_id])
  end
end
