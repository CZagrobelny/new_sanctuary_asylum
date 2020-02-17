class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  helper_method :current_community, :current_region

  def current_community
    return @current_community if @current_community

    if params[:community_slug]
      return @current_community = Community.find_by_slug(params[:community_slug])
    end

    @current_community = Community.find(current_user.community_id)
  end

  def current_region
    return @current_region if @current_region

    if params[:region_id]
      return @current_region = Region.find(params[:region_id])
    end

    @current_region = current_community.region
  end

  def require_admin
    not_found unless current_user.admin?
  end

  def require_admin_or_access_time_slot
    unless current_user.admin? || current_user.has_active_data_entry_access_time_slot?
      not_found
    end
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

  def require_admin_or_remote_lawyer
    not_found unless current_user.admin? || current_user.existing_remote_relationship?(params[:friend_id])
  end
end
