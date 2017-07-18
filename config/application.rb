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
  end
end

Raven.configure do |config|
  config.dsn = 'https://3a9acf293f634f5a9966364b61f08d1c:deb985cf38e540fab126d0168caf2167@sentry.io/192464'
  #config.attr = 'value'
end
