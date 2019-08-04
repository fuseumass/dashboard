if [ \( ! -f "db/development.sqlite3" \) -o \( ! -f "db/test.sqlite3" \) ]; then
  echo Development db or test db does not exist. Running initial setup... &&
  bundle exec rake db:migrate  &&
  bundle exec rake db:setup &&
  bundle exec rake feature_flags:load_flags
fi
bundle exec rails server