SecureHeaders::Configuration.default do |config|  
  config.csp = {
    report_only: Rails.env.production?, # default: false
    preserve_schemes: true, # default: false.
    default_src: %w(*), # all allowed in the beginning
    script_src: %w('self'),
    connect_src: %w('self'),
    style_src: %w('self' 'unsafe-inline'),
    report_uri: ["/csp_report?report_only=#{Rails.env.production?}"]
  }
end 
# https://bauland42.com/ruby-on-rails-content-security-policy-csp/