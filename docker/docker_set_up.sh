# Work around for the pesky "server is already running bug"
rm tmp/pids/server.pid

if [ \( ! -f "db/postgres/.built" \) ]; then
  echo Development db or test db does not exist. Running initial setup... &&
  bundle exec rake db:create  &&
  bundle exec rake db:migrate  &&
  bundle exec rake db:setup &&
  bundle exec rake feature_flags:load_flags
  touch db/postgres/.built
fi
bundle exec rails server -b 0.0.0.0