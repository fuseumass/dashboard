cat << "EOF"
/$$   /$$                     /$$       /$$   /$$ /$$      /$$
| $$  | $$                    | $$      | $$  | $$| $$$    /$$$
| $$  | $$  /$$$$$$   /$$$$$$$| $$   /$$| $$  | $$| $$$$  /$$$$  /$$$$$$   /$$$$$$$  /$$$$$$$
| $$$$$$$$ |____  $$ /$$_____/| $$  /$$/| $$  | $$| $$ $$/$$ $$ |____  $$ /$$_____/ /$$_____/
| $$__  $$  /$$$$$$$| $$      | $$$$$$/ | $$  | $$| $$  $$$| $$  /$$$$$$$|  $$$$$$ |  $$$$$$
| $$  | $$ /$$__  $$| $$      | $$_  $$ | $$  | $$| $$\  $ | $$ /$$__  $$ \____  $$ \____  $$
| $$  | $$|  $$$$$$$|  $$$$$$$| $$ \  $$|  $$$$$$/| $$ \/  | $$|  $$$$$$$ /$$$$$$$/ /$$$$$$$/
|__/  |__/ \_______/ \_______/|__/  \__/ \______/ |__/     |__/ \_______/|_______/ |_______/
EOF

echo ' '
echo 'Are you ready to deploy?'
echo -n 'Enter the Heroku name of the application: '
read heroku_name
echo "Heroku app name: $heroku_name"


echo ' '
echo "Preparing for deployment to $heroku_name....."
echo ' '

# Asset precompilation
echo 'Precompiling Assets...'
bundle exec rake assets:precompile
echo 'Assets precompiled succesfully ✅'
echo ' '

# Committing Assets
echo 'Committing precompiled assets temporarily....'
git add .
git commit --allow-empty -m "Assets precompiled" 

# Pushing build to Heroku
echo ' '
echo 'Pushing build to Heroku....'
git push -f heroku master
echo ' '
echo 'Heroku Build Successful ✅'
echo ' '

# Undo precompile commit
echo 'Undoing precompile commit'
git reset HEAD~1
echo 'Undone. Pushing to master....'
git push

# Migrations
echo 'Do you want to migrate the production database? (type y or n)'
read migrate
if [[ $migrate = 'y' ]]; then
  echo 'Application entering maintenance mode...'
  heroku maintenance:on -a $heroku_name
  echo ' '
  echo 'Migrating databases....'
  heroku run rake db:migrate -a $heroku_name
  echo ' '
  echo 'Database Migration Successful ✅'
  echo ' '
  echo 'Application exiting maintenance mode...'
  heroku maintenance:off -a $heroku_name
  echo ' '
else
  echo 'Skipping maintenance mode. No migrations found. ✅'
fi

# Feature flag updates
echo 'Do you want to update the feature flag? (type y or n)'
read fflag
if [[ $fflag = 'y' ]]; then
  echo 'Running feature flag script...'
  heroku run rake feature_flags:load_flags
  echo ' '
  echo 'Feature flags successfully added to database ✅'
  echo ' '

else
  echo 'Skipping feature flag script ✅'
fi

# All good!
echo 'HackUMass Web App Has Been Deployed ✅'
