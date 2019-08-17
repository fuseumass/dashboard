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

    config=YAML.load_file('hackathon-config/hackathon.yml')

    COPY_FOLDER = File.expand_path('hackathon-config/copy')
    def copy_for(name)
      if name.end_with?(".erb")
        "#{COPY_FOLDER}/#{name}"
      else
        "#{COPY_FOLDER}/#{name}.html.erb"
      end
    end

    # ----------- BEGIN YOUR CONFIGURATION HERE ------------
    # Variables neeeded for configuration of hackathon dashboard
    HACKATHON_NAME = config["name"]
    HACKATHON_VERSION = config["version"]
    MAIN_WEBSITE = config["main_website"]
    DASHBOARD_URL = config["dashboard_url"]
    LOGO_PATH = config["logos"]["primary_path"]
    NAV_LOGO_PATH = config["logos"]["nav_path"]
    DONOTREPLY = config["emails"]["donotreply"]
    CONTACT_EMAIL = config["emails"]["contact"]
    SLACK_SUBDOMAIN = config["slack"]["subdomain"]
    USE_WAITLISTS = config["use_waitlists"]

    # ----------- DO NOT EDIT BELOW THIS LINE ------------
    # Secret keys for various external services, these keys/tokens are loaded from the secrets.yml file
    # Please first create & then paste your keys into secrets.yml following the format provided in the documentation
    SLACK_WORKSPACE_TOKEN = ENV['SLACK_TOKEN']
    SLACK_JOIN_URL = ENV['SLACK_JOIN_URL']
  end
end

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = %w[ production ]
end
