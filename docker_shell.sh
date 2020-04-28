RUNNING_ID=`docker ps --format '{{.ID}}' -f 'ancestor=dashboard_hackathon-dashboard'`
if [[ "$RUNNING_ID" == "" ]]; then
    echo Running new container instance
    ./docker_run.sh ${@:-/bin/bash}
else
    echo Connecting to running container instance
    docker-compose exec hackathon-dashboard ${@:-/bin/bash}
fi
