CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('LEGACY_AWS_S3_BUCKET_NAME')
    config.aws_acl    = 'private'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 10.minutes.to_i

    # Set custom options such as cache control to leverage browser caching
    config.aws_attributes = {
      expires: 1.week.from_now.to_i,
      cache_control: 'max-age=604800'
    }

    config.aws_credentials = {
      access_key_id:     ENV.fetch('LEGACY_AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('LEGACY_AWS_SECRET_ACCESS_KEY'),
      region:            ENV.fetch('LEGACY_AWS_REGION') # Required
    }
  else
    config.storage = :file
    config.enable_processing = false
  end
end