if [ \( ! -f "db/.built" \) ]; then
  echo Development db or test db does not exist. Running initial setup... &&
  bundle exec rake db:create  &&
  bundle exec rake db:migrate  &&
  bundle exec rake db:setup &&
  bundle exec rake feature_flags:load_flags
  touch db/.built
fi
bundle exec rails server