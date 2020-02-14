cat << "EOF"
---------------------------------------------------------------
    ______                    __  __ __  ___                  
   / ____/__  __ _____ ___   / / / //  |/  /____ _ _____ _____
  / /_   / / / // ___// _ \ / / / // /|_/ // __ `// ___// ___/
 / __/  / /_/ /(__  )/  __// /_/ // /  / // /_/ /(__  )(__  ) 
/_/     \__,_//____/ \___/ \____//_/  /_/ \__,_//____//____/  
                            

    ____                __     __                             __
   / __ \ ____ _ _____ / /_   / /_   ____   ____ _ _____ ____/ /
  / / / // __ `// ___// __ \ / __ \ / __ \ / __ `// ___// __  / 
 / /_/ // /_/ /(__  )/ / / // /_/ // /_/ // /_/ // /   / /_/ /  
/_____/ \__,_//____//_/ /_//_.___/ \____/ \__,_//_/    \__,_/   
                                                                
---------------------------------------------------------------
EOF

echo ' '
echo 'Deploy Dashboard to Heroku.'

CONFIG_NAME=$(cat hackathon-config/hackathon.yml | head -n 1 | cut -d ':' -f 2)

if [[ "$CONFIG_NAME" == " RedPandaHacks" ]]; then
    echo ""
    echo "WARNING! You are about to deploy with the example configuration repository"
    echo "(github.com/hackumass/redpandahacks-config). Are you sure you want to do this?"
    echo "For instructions on how to provide your own configuration repository, read the"
    echo "Dashboard Wiki (github.com/hackumass/dashboard/wiki)."
else
    echo "Deploying with the$CONFIG_NAME configuration repository."
fi



echo -n 'Enter the name of the application on Heroku: '
read heroku_name
echo "Heroku app name: $heroku_name"


echo ' '
echo "Preparing for deployment to $heroku_name..."
echo "Fetching remote heroku-$heroku_name"
git fetch "heroku-$heroku_name"
if [[ "$?" != "0" ]]; then
    echo "Git remote doesn't exist. Would you like to add a new deployment target? (type y or n)"
    read ok
    if [[ $ok = 'y' ]]; then
        git remote add "heroku-$heroku_name" "https://git.heroku.com/$heroku_name.git"
        if [[ "$?" != "0" ]]; then
            echo 'Exiting.'
            exit 1
        else
            echo "Successfully added git remote heroku-$heroku_name for heroku instance $heroku_name"
            git fetch "heroku-$heroku_name"
        fi
    else
        echo 'Exiting.'
        exit 1
    fi
fi
echo ' '

# Asset precompilation
echo 'Precompiling Assets...'
./docker_shell.sh bundle exec rake assets:precompile
if [[ "$?" != "0" ]]; then
	echo 'Precompilation Failed. Ensure Docker is running and restart.'
	exit 1
fi
echo 'Assets precompiled succesfully ✅'
echo ' '

echo 'Checking git submodule configuration...'
SUBMOD_URL=`git config --file=.gitmodules submodule.hackathon-config.url`
SUBMOD_CHANGED=0
if [[ $SUBMOD_URL == git@github.com:* ]]; then
    echo 'Modifying git submodule to have https URL. The repository will need to be public.'
    git config --file=.gitmodules submodule.hackathon-config.url `echo $SUBMOD_URL|sed 's/git@github.com:/https:\/\/github.com\//g'`
    echo 'Updated git submodule URL. Running sync and update...'
    git submodule sync
    git submodule update --init --recursive --remote
    echo 'Submodule changes done.'
    SUBMOD_CHANGED=1
fi

# Committing Assets
echo 'Committing precompiled assets and submodule config temporarily....'
git add .
git commit --allow-empty -m "Assets precompiled with submodule"


# Pushing build to Heroku
echo ' '
echo 'Pushing build to Heroku....'
git push -f "heroku-$heroku_name" master

application_mode=`heroku config:get APPLICATION_MODE -a $heroku_name`
mentor_code=`heroku config:get MENTOR_CODE -a $heroku_name`
if [ "$application_mode" == "" ] || [ "$mentor_code" == "" ]
then
    echo '[>----------------------------------'
    echo 'Creating Environment Variables...'
    echo '[>----------------------------------'

    if [ "$application_mode" == "" ]
        heroku config:set APPLICATION_MODE=closed -a $heroku_name
        echo ''
        echo 'Created Application Mode Environment Variable.'
    fi

    if [ "$mentor_code" == "" ]
        mentorkey=`openssl rand -base64 12`
        heroku config:set MENTOR_CODE="$mentorkey" -a $heroku_name
        echo ''
        echo 'Created Mentor Code Environment Variable.'
    fi

    echo ""
    echo "Environment Variables Created!"
else
    echo "Environment Variables Already Created."
fi


echo ' '
echo 'Heroku Build Successful ✅'
echo ' '

if [[ $SUBMOD_CHANGED = 1 ]]; then
    echo 'Reverting git submodule to old URL....'
    git config --file=.gitmodules submodule.hackathon-config.url $SUBMOD_URL
    echo 'Fixed git submodule URL. Running sync and update...'
    git submodule sync
    git submodule update --init --recursive --remote
    echo 'Submodule URL fixed.'
    echo ' '
fi

# Undo precompile commit
echo 'Undoing precompile commit'
git reset HEAD~1
echo 'Undone. Pushing to master....'
git push

# Migrations
echo 'Do you want to migrate the production database? (type y or n)'
echo 'NOTE: This will put the application in maintenance mode and have some downtime.'
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
  echo 'Skipping Database Migrations ✅'
fi

# Feature flag updates
echo 'Do you want to update the feature flag? (type y or n)'
read fflag
if [[ $fflag = 'y' ]]; then
  echo 'Running feature flag script...'
  heroku run rake feature_flags:load_flags -a $heroku_name
  echo ' '
  echo 'Feature flags successfully added to database ✅'
  echo ' '

else
  echo 'Skipping feature flag script ✅'
fi

# All good!
echo 'HackUMass Web App Has Been Deployed ✅'
