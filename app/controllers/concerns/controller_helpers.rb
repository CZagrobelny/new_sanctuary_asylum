module ControllerHelpers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, :with => :handle_404_exception unless Rails.env.development?
    rescue_from RedirectException, :with => :handle_redirect_exception
    rescue_from RenderException, :with => :handle_render_exception
    rescue_from AuthorizationException, :with => :handle_authorization_exception
    rescue_from ActionController::ParameterMissing do
      render :nothing => true, :status => 400
    end

    helper_method :current_user
    helper_method :current_user?
  end


  class_methods do
    def require_login(options = {})
      before_action(options) do
        unless current_user
          redirect_to new_session_path(:back_to => request.fullpath)
        end
      end
    end

    def require_flag(flag, options = {})
      require_login(options)

      before_action(options) do
        if !current_user.respond_to?(flag) || !current_user.public_send(flag)
          render 'common/no_access'
        end
      end
    end
  end

  class RedirectException < ::Exception
  end

  class RenderException < ::Exception
  end

  class AuthorizationException < ::Exception
  end

protected

  def handle_404_exception
    raise ActionController::RoutingError.new('Not Found')
  end

  def handle_redirect_exception
    redirect_to $!.message
  end

  def handle_render_exception
    render $!.message
  end

  def handle_authorization_exception
    render 'common/no_access', :status => 401
  end

  def current_user?
    current_user.present?
  end

  def require_login
    unless current_user
      raise RedirectException, new_session_path(:back_to => request.fullpath)
    end
  end

  def require_flag(flag)
    require_login

    if !current_user.respond_to?(flag) || !current_user.public_send(flag)
      raise RenderException, 'common/no_access'
    end
  end
end
