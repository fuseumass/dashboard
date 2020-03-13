#!/bin/bash
docker-compose build
docker-compose run dashboard rake db:create db:migrate feature_flags:load_flags