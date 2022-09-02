#!/usr/bin/env bash

set -e

if [[ "${OSTYPE}" == "darwin"* ]]; then
  COMPOSE_PROJECT_NAME=$(cat .env | cut -d'=' -f 2)
  PROJECT_LOCATION="${PWD}/../../magento-enterprise"

  docker-compose -f docker-compose-mac.yml down -v
  docker-compose -f docker-compose-mac.yml up --detach --remove-orphans --build
  if [[ ! $(mutagen sync list --label-selector=name=="${COMPOSE_PROJECT_NAME}") =~ "${COMPOSE_PROJECT_NAME}" ]]; then
    mutagen sync create \
			--label=name="${COMPOSE_PROJECT_NAME}" \
			--default-file-mode="0664" \
			--default-directory-mode="0755" \
			--sync-mode="two-way-resolved" \
			--ignore-vcs --ignore="pub/static" \
			--ignore="var/page_cache/**" --ignore="var/composer_home/**" \
			--ignore="app/code/**" --ignore="app/design/**" \
			--ignore="var/view_preprocessed/**" --ignore="generated/**" \
			--symlink-mode="posix-raw" \
		"${PROJECT_LOCATION}" "docker://${COMPOSE_PROJECT_NAME}_code-sync/var/www/magento2/";
	else
		mutagen sync resume --label-selector=name=="${COMPOSE_PROJECT_NAME}";
  fi
  while [[ ! $(mutagen sync list --label-selector=name=="${COMPOSE_PROJECT_NAME}") =~ "Status: Watching for changes" ]]; do \
		echo "Waiting for synchronization to complete..."; \
		sleep 10; \
	done
	docker compose exec -T php bash -c "sudo chown -R www-data:www-data /var/www/magento2"
elif [[ "${OSTYPE}" == "linux"* ]]; then
  docker-compose -f docker-compose-linux.yml down -v
  docker-compose -f docker-compose-linux.yml up -d --build
else
  docker-compose -f docker-compose.yml down -v
  docker-compose -f docker-compose.yml up -d --build
fi
