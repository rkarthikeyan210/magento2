#!/bin/bash
cd /var/www/magento2/
php bin/magento maintenance:enable
sleep 5
php bin/magento setup:upgrade
php bin/magento deploy:mode:set production
php bin/magento config:set web/unsecure/base_url http://ecsd00300856.epam.com:$NGINX_PORT/
php bin/magento c:c
php bin/magento maintenance:disable