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
echo 'Precompiling Assets...'
RAILS_ENV=production bundle exec rake assets:precompile
echo 'Assets precompiled succesfully ✅'
echo ' '
echo 'Pushing build to Heroku....'
git push heroku master
echo ' '
echo 'Heroku Build Sucessfull ✅'
echo 'Migrating databases....'
heroku run rake db:migrate
echo ' '
echo 'Database Migration Succesfull ✅'
echo ' '
echo 'HackUMass Web App Has Been Deployed ✅'
