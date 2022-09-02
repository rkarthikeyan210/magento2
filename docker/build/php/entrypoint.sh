#!/usr/bin/env bash
set -e

echo "Start cron service"
sudo /etc/init.d/cron start

echo "Initial crontab for www-data"
crontab /etc/cron.d/crontab

echo "Restart cron service"
sudo /etc/init.d/cron restart

exec "$@"