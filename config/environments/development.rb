Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Allow for local development with Docker
  config.web_console.whitelisted_ips = '172.17.0.1'

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
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # setup paperclip to use AWS S3
  # config.paperclip_defaults = {
  #     storage: :s3,
  #     s3_region: 'us-east-1',
  #     s3_protocol: 'https',
  #     s3_credentials: {
  #         bucket: 'hackumass-vi-dev',
  #         access_key_id: 'XXX',
  #         secret_access_key: 'XXX'
  #     }
  # }

  # WARNING: This will raise an error if you attach a resume when submitting an application
  # To test how resume get uploaded to Azure, use container 'humdbstaging' from Azure
  Paperclip::Attachment.default_options[:storage] = :azure
  Paperclip::Attachment.default_options[:azure_credentials] = {
      storage_account_name: 'xxx',
      storage_access_key:   'xxx',
      container:            'xxx'
  }
end
