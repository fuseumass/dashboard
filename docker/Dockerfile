FROM ruby:2.5

# Installs dependencies to run Rails on the ruby:2.5 image
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  postgresql-client

# Configure the main working directory
WORKDIR /usr/src/app

# Copies the Gemfile and Gemfile.lock to the main working directory
COPY Gemfile Gemfile.lock ./

# Installs gems listed in the Gemfile.lock
RUN bundle install

# Copies the main application to run install dependencies and rake files
COPY . .

# Exposes the 3000 port to access it outside of the image
EXPOSE 3000

# Default command that runs when the container starts
CMD ["bash", "docker/docker_set_up.sh"]