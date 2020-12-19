module DeviseOverrides
  module DeviseAuthyControllersHelpers

    private
    def require_token?
      id = warden.session(resource_name)[:id]
      resource = resource_class.find(id)

      log_user_and_ip(resource)

      cookie = cookies.signed[:remember_device]
      return true if cookie.blank?

      # require token for old cookies which just have expiration time and no id
      return true if cookie.to_s =~ %r{\A\d+\z}

      cookie = JSON.parse(cookie) rescue ""
      return true if cookie.blank?

      cookie_set_at = cookie['expires'].to_i

      # Overriding to require 2FA token for all cookies created before a user's password changed
      return true if cookie_set_prior_to_password_change?(cookie_set_at: cookie_set_at, resource: resource)

      (Time.now.to_i - cookie_set_at) > resource_class.authy_remember_device.to_i ||
        cookie['id'] != id
    end

    def cookie_set_prior_to_password_change?(cookie_set_at:, resource:)
      cookie_set_at < resource.password_changed_at.to_i
    end

    def log_user_and_ip(resource)
      Rails.logger.info "Checking 2FA: user=#{resource.email}, ip=#{request.remote_ip}"
    end
  end
end