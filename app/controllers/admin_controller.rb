class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_access_time_slot
  before_action :require_access_to_community
  after_action :log_action

  private

  def log_action
    did_use_2fac = session['user_authy_token_checked'];
    Rails.logger.info "ADMIN [email=#{current_user.email}, "\
    "Used Authy to 2fac= #{did_use_2fac ? 'YES' : 'NO'}, "\
    "ip=#{request.remote_ip}]:  #{request_path_parameters} "\
    "#{request_query_parameters} "
  end

  def request_path_parameters
    "PATH: #{request.path_parameters}"
  end

  def request_query_parameters
    "QUERY: #{request.query_parameters}" if request.query_parameters.present?
  end
end
