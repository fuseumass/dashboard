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

    # ----------- BEGIN YOUR CONFIGURATION HERE ------------
    # Variables neeeded for configuration of hackathon dashboard
    HACKATHON_NAME = "HackUMass"
    HACKATHON_VERSION = "VII" # Could also be a roman numeral or other number, will be concatenated with the hackathon name where necessary
    MAIN_WEBSITE = "https://hackumass.com"
    DASHBOARD_URL = "dashboard.hackumass.com"
    DONOTREPLY = "donotreply.hackumass@gmail.com"
    CONTACT_EMAIL = "team@hackumass.com"

    # ----------- DO NOT EDIT BELOW THIS LINE ------------
    # Secret keys for various external services, these keys/tokens are loaded from the secrets.yml file
    # Please first create & then paste your keys into secrets.yml following the format provided in the documentation
    SLACK_WORKSPACE_TOKEN = tokens["slack"]
  end
end

Raven.configure do |config|
  config.dsn = 'https://3a9acf293f634f5a9966364b61f08d1c:deb985cf38e540fab126d0168caf2167@sentry.io/192464'
  config.environments = %w[ production ]
end
