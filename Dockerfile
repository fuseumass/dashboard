FROM ruby:2.5

# Installs dependencies to run Rails on the ruby:2.5 image
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs

# Configure the main working directory
WORKDIR /usr/src/app

# Copies the main application to run install dependencies and rake files
COPY . .

# Installs gems listed in the Gemfile.lock
RUN bundle install

# Exposes the 3000 port to access it outside of the image
EXPOSE 3000

# Default command that runs when the container starts
CMD ["bash", "./docker_set_up.sh"]