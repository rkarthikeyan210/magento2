#!/usr/bin/env bash

set -e

if [[ "${OSTYPE}" == "darwin"* ]]; then
  COMPOSE_PROJECT_NAME=$(cat .env | cut -d'=' -f 2)
  docker-compose -f docker-compose-mac.yml down
  mutagen sync pause --label-selector=name=="${COMPOSE_PROJECT_NAME}"
elif [[ "${OSTYPE}" == "linux"* ]]; then
  docker-compose -f docker-compose-linux.yml down
else
  docker-compose -f docker-compose.yml down
fi
