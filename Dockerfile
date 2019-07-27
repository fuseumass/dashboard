FROM ruby:2.5

# Installs dependencies to run Rails on the ruby:2.5 image
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs

# Configure the main working directory
WORKDIR /usr/src/app

# Installs gems listed in the Gemfile.lock
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copys th main application
COPY . .

# Runs the starting rake command (db:migrate listed as a placeholder for issue #21)
RUN bundle exec rake db:migrate
RUN bundle exec rake db:seed
RUN bundle exec rake feature_flags:load_flags

# Exposes the 3000 port to access it outside of the image
EXPOSE 3000

# Default command that runs when the container starts
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]