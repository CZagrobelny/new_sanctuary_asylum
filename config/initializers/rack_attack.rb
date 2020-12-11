class Rack::Attack
  if !Rails.env.development? && !Rails.env.test?
    ### Block IPs ###
    if ENV['RACK_ATTACK_IPS'].present?
      blocklist('block by IP') do |req|
        ENV['RACK_ATTACK_IPS'].split(',').include?(req.ip)
      end
    end

    ### Throttle Spammy Clients ###

    # If any single client IP is making tons of requests, then they're
    # probably malicious or a poorly-configured scraper. Either way, they
    # don't deserve to hog all of the app server's CPU. Cut them off!
    #
    # Note: If you're serving assets through rack, those requests may be
    # counted by rack-attack and this throttle may be activated too
    # quickly. If so, enable the condition to exclude them from tracking.

    # throttle = false if Rails.env.test? && !ENV["THROTTLE_DURING_TEST"]

    # Throttle all requests by IP (60rpm)
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
    throttle('req/ip', :limit => 20, :period => 20.seconds) do |req|
      req.ip # unless req.path.start_with?('/assets')
    end

    ### Prevent Brute-Force Login Attacks ###

    # The most common brute-force login attack is a brute-force password
    # attack where an attacker simply tries a large number of emails and
    # passwords to see if any credentials match.
    #
    # Another common method of attack is to use a swarm of computers with
    # different IPs to try brute-forcing a password for a specific account.

    # Throttle POST requests to /login by IP address
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
    throttle('users/sign_in/ip', :limit => 5, :period => 20.seconds) do |req|
      if req.path == '/users/sign_in' && req.post?
        req.ip
      end
    end

    # Throttle POST requests to /login by email param
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{req.email}"
    #
    # Note: This creates a problem where a malicious user could intentionally
    # throttle logins for another user and force their login requests to be
    # denied, but that's not very common and shouldn't happen to you. (Knock
    # on wood!)
    throttle("users/sign_in", :limit => 5, :period => 20.seconds) do |req|
      if req.path == '/users/sign_in' && req.post?
        # return the email if present, nil otherwise
        req.params['email'].presence
      end
    end
  end
end