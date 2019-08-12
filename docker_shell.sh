docker exec -it `docker ps --format '{{.ID}}' -f 'ancestor=hackathon-dashboard'` ${@:-/bin/bash}
