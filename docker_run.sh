#!/bin/bash
docker run -v `pwd`:/usr/src/app -p 3000:3000 -it hackathon-dashboard "$@"