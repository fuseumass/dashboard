Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Environment optons required by Devise
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # config.action_mailer.default_url_options = { :host => 'dashboard.hackumass.com' }

  # Do not send emails while in development
  config.action_mailer.perform_deliveries = true

  config.action_mailer.delivery_method = :smtp
  # SMTP settings for amazon ses
  # config.action_mailer.smtp_settings = {
  #     :address => "email-smtp.us-east-1.amazonaws.com",
  #     :port => 587,
  #     :user_name => 'AKIAIS5JEPUJFKVSFKXA', #Your SMTP user
  #     :password => 'Aji7htpSp4KUt2oNJpq+sfOuz/xgXoMEgZuht/Wnz4j/', #Your SMTP password
  #     :authentication => :login,
  #     :enable_starttls_auto => true
  # }

  # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "gmail.com",
      :user_name => 'donotreply.hackumass@gmail.com', #Your SMTP user
      :password => 'eR499@Z0', #Your SMTP password
      :authentication => :plain,
      :enable_starttls_auto => true
  }

  #config.action_mailer.delivery_method = :smtp

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # setup paperclip to use AWS S3
  config.paperclip_defaults = {
      storage: :s3,
      s3_region: 'us-east-1',
      s3_protocol: 'https',
      s3_credentials: {
          bucket: 'hackumass-vi-dev',
          access_key_id: 'AKIAJ5P3U5WOPYCC6CJQ',
          secret_access_key: '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'
      }
  }
end
