CURR_DIR="${PWD##*/}"

RUNNING_ID="docker ps --format '{{.ID}}' -f 'ancestor=${CURR_DIR}-rails'"
if [[ "$RUNNING_ID" == "" ]]; then
    echo Running new container instance
    ./docker/docker_run.sh ${@:-/bin/bash}
else
    echo Connecting to running container instance
    docker-compose exec rails ${@:-/bin/bash}
fi
