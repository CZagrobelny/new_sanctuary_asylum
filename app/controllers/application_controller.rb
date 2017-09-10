class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  def require_admin
    not_found unless current_user.admin?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
