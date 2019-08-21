RUNNING_ID=`docker ps --format '{{.ID}}' -f 'ancestor=hackathon-dashboard'`
if [[ "$RUNNING_ID" == "" ]]; then
    echo Running new container instance
    ./docker_run.sh ${@:-/bin/bash}
else
    echo Connecting to running container instance $RUNNING_ID
    docker exec -it $RUNNING_ID ${@:-/bin/bash}
fi
