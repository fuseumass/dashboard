require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HackumassWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Eastern Time (US & Canada)'

    # Variables neeeded for configuration of hackathon dashboard
    HACKATHON_NAME = "HackHer"
    HACKATHON_VERSION = "2018" # Could also be a roman numeral or other number, will be concatenated with the hackathon name where necessary
  end
end

Raven.configure do |config|
  config.dsn = '***REMOVED***
  config.environments = %w[ production ]
end
