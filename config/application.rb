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

    tokens=YAML.load_file('config/secrets.yml')
    config=YAML.load_file('config/hackathon.yml')

    # ----------- BEGIN YOUR CONFIGURATION HERE ------------
    # Variables neeeded for configuration of hackathon dashboard
    HACKATHON_NAME = config["name"]
    HACKATHON_VERSION = config["version"]
    MAIN_WEBSITE = config["main_website"]
    DASHBOARD_URL = config["dashboard_url"]
    DONOTREPLY = config["donotreply"]
    CONTACT_EMAIL = config["contact_email"]

    # ----------- DO NOT EDIT BELOW THIS LINE ------------
    # Secret keys for various external services, these keys/tokens are loaded from the secrets.yml file
    # Please first create & then paste your keys into secrets.yml following the format provided in the documentation
    SLACK_WORKSPACE_TOKEN = tokens["slack"]
  end
end

Raven.configure do |config|
  config.dsn = '***REMOVED***
  config.environments = %w[ production ]
end
