require "sentry/rails"

Sentry.init do |config|
  # Your DSN from Sentry (set it as an ENV var on Heroku)
  config.dsn = ENV["SENTRY_DSN"]

  # Only send events from these environments
  config.enabled_environments = %w[production staging]

  # Optional: explicitly name the environment (falls back to Rails.env)
  config.environment = ENV.fetch("SENTRY_ENV", Rails.env)

  # Breadcrumbs from Rails & HTTP
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Performance tracing (set to >0 only if you want APM traces)
  # e.g. 0.2 to sample ~20% of requests
  config.traces_sample_rate = (ENV["SENTRY_TRACES_SAMPLE_RATE"] || "0.0").to_f

  # Don’t send PII by default
  config.send_default_pii = false

  # Common “noise” you may want to ignore
  config.excluded_exceptions += [
    "ActionController::RoutingError",
    "ActiveRecord::RecordNotFound"
  ]

end