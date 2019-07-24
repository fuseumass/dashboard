FROM ruby:2.5.5

RUN apt-get update
RUN apt-get install -y build-essential 

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

WORKDIR /app
ENV PATH="/root/.local/bin:${PATH}"


RUN gem install bundler -v 1.16.6

RUN bundle install

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server"]