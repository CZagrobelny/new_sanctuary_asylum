class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :require_access_to_community
  after_action :log_action

  private
  def require_admin
    not_found unless current_user.admin?
  end

  def require_access_to_community
    not_found unless current_user.can_access?(current_community)
  end

  def log_action
    Rails.logger.info "ADMIN [#{current_user.email}, ip: #{request.remote_ip}]:  #{request_path_parameters} #{request_query_parameters}"
  end

  def request_path_parameters
    "PATH: #{request.path_parameters}"
  end

  def request_query_parameters
    "QUERY: #{request.query_parameters}" if request.query_parameters.present?
  end
end
