#!/bin/bash
docker-compose run -v `pwd`:/usr/src/app -p 3000:3000 rails "$@"