bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake feature_flags:load_flags
bundle exec rails server