require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

#
# When updating this file, make sure you restart the Rails dev server.
#
module HackumassWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Eastern Time (US & Canada)'

    config=YAML.load_file('hackathon-config/hackathon.yml')
    event_application_config=YAML.load_file('hackathon-config/event_application.yml') || {} if File.exists?('hackathon-config/event_application.yml')
    rsvp_custom_fields = YAML.load_file('hackathon-config/rsvp_questions.yml') || {} if File.exists?('hackathon-config/rsvp_questions.yml')

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
    FAVICON_URL = config["logos"]["favicon_url"]
    DONOTREPLY = config["emails"]["donotreply"]
    CONTACT_EMAIL = config["emails"]["contact"]
    SLACK_SUBDOMAIN = config["slack"]["subdomain"]
    APPLICATIONS_MODE = config["applications"]["mode"]
    CHECKIN_UNIVERSITY_EMAIL_SUFFIX = config["checkin"]["university_email_suffix"]
    CHECKIN_UNIVERSITY_NAME = config["checkin"]["university_name"]
    CHECKIN_UNIVERSITY_NAME_CHECKS = config["checkin"]["university_name_checks"]
    PROJECTS_PUBLIC = config["projects"]["public"]
    HACKING_BEGINS_DATE = config["projects"]["hacking_begins"]
    HACKING_ENDS_DATE = config["projects"]["hacking_ends"]
    SLACK_MESSAGE_URL_PREFIX = config["slack"]["message_url_prefix"]

    if event_application_config
      EVENT_APPLICATION_CUSTOM_FIELDS = event_application_config["custom_fields"] or []
      EVENT_APPLICATION_OPTIONS = event_application_config["options"] or {}
    else
      EVENT_APPLICATION_CUSTOM_FIELDS = []
      EVENT_APPLICATION_OPTIONS = {}
    end

    if rsvp_custom_fields
      RSVP_CUSTOM_FIELDS = rsvp_custom_fields["custom_questions"] or []
    else
      RSVP_CUSTOM_FIELDS = []
    end

    # ----------- DO NOT EDIT BELOW THIS LINE ------------
    # Secret keys for various external services, these keys/tokens are loaded from the secrets.yml file
    # Please first create & then paste your keys into secrets.yml following the format provided in the documentation
    SLACK_WORKSPACE_TOKEN = ENV['SLACK_TOKEN']
    SLACK_JOIN_URL = ENV['SLACK_JOIN_URL']
    SLACKINTEGRATION_TOKEN = ENV['SLACKINTEGRATION_TOKEN']
    SLACKINTEGRATION_BOT_ACCESS_TOKEN = ENV['SLACKINTEGRATION_BOT_ACCESS_TOKEN']
  end
end

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = %w[ production ]
end
