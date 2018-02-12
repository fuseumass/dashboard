source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Jquery datetime picker
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'momentjs-rails', '>= 2.9.0'
# File Uploads
gem "paperclip", "~> 5.2.1"
# Graphs and all that jazz for statistics
gem 'chartkick'
gem 'groupdate'
# Easy debugging
gem 'pry-rails', group: :development
# For easy search on hardware
gem 'searchkick'
# The theme we use on top of rails
gem 'bootswatch-rails'
# The most beautiful framework
gem 'bootstrap-sass', '~> 3.3.6'
# The devise gem helps us authenticate users securely
gem 'devise'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Required for autocomplete
gem 'jquery-ui-rails'

# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere
  # in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Amazon Web Services gem use for emailing and cloud storage
gem 'aws-sdk-s3' # cloud storage
gem 'aws-sdk-ses' # emailing

# Use for uploading file to cloud storage
gem 'carrierwave'

# Use to help parse pdf file (specifically the resume files)
gem 'pdf-reader'

# Adds autocompletion feature to website
gem 'rails-jquery-autocomplete'

# Adds pagination feature to website
gem 'will_paginate'

# Gem use to track and report errors on website
gem 'sentry-raven'
