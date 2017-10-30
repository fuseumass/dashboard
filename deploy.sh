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
echo 'Preparing HackUMass Web App For Deployment.....'
echo ' '

# Asset precompilation
echo 'Precompiling Assets...'
RAILS_ENV=production bundle exec rake assets:precompile
echo 'Assets precompiled succesfully ✅'
echo ' '

# Committing Assets
echo 'Committing precompiled assets to master....'
git add .
git commit -m "Assets precompiled"
git push
echo ' '
echo 'Precompiled assets have been pushed to master ✅'

# Pushing build to Heroku
echo ' '
echo 'Pushing build to Heroku....'
git push heroku master
echo ' '
echo 'Heroku Build Sucessfull ✅'
echo ' '

# Put the app on maintenance mode and migrate the database
echo 'Skipping maintenance mode. No migrations found. ✅'
echo 'Application entering maintenance mode...'
heroku maintenance:on
echo ' '
echo 'Migrating databases....'
heroku run rake db:migrate
echo ' '
echo 'Database Migration Successful ✅'
echo ' '
echo 'Application exiting maintenance mode...'
heroku maintenance:off
echo ' '

# All good!
echo 'HackUMass Web App Has Been Deployed ✅'
