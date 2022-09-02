ARG PHP_VERSION=7.4-fpm

FROM php:${PHP_VERSION}
ARG WITH_XDEBUG
ARG BASE_CODE_FOLDER

LABEL maintainer="kramu@incomm.com"
LABEL description="Incomm Magento EE 2.4.2 docker instance build."

ENV INSTALL_DIR /var/www/magento2
ENV SSH_USER root
ENV SSH_PASSWORD root

RUN requirements="libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libpng-dev libfreetype6-dev libicu-dev libxslt1-dev libonig-dev libzip-dev libsodium-dev" \
    && apt-get update \
    && apt-get install -y $requirements \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd  --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath \
	&& docker-php-ext-install sockets \
    && requirementsToRemove="libcurl3-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN if [ "$WITH_XDEBUG" = "1" ] ; then pecl install xdebug && docker-php-ext-enable xdebug; fi

RUN pecl install -f libsodium-1.0.17

RUN apt-get update \
	&& apt-get install -y openssh-server \
	sudo \
	vim \
	openssh-server \
	curl \
	gnupg \
	&& curl -sL https://deb.nodesource.com/setup_14.x | bash - \
	&& apt-get install -y nodejs \
	&& npm install -g grunt-cli

RUN apt-get install cron --no-install-recommends -y
RUN apt-get install mariadb-client -y

RUN echo "memory_limit=2048M" >> /usr/local/etc/php/conf.d/common.ini \
	&& echo "max_execution_time=1000" >> /usr/local/etc/php/conf.d/common.ini \
	&& echo "max_input_time=1000" >> /usr/local/etc/php/conf.d/common.ini

RUN if [ "$WITH_XDEBUG" = "1" ] ; then echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; fi

RUN mkdir /var/run/sshd
RUN echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

RUN usermod -aG sudo www-data && echo "www-data ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY build/php/entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN cd /usr/local/bin && curl -sS -O https://files.magerun.net/n98-magerun2.phar
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN mkdir -p /var/www/.composer && chown www-data:www-data /var/www/.composer \
    && mkdir -p /var/www/.npm && chown www-data:www-data /var/www/.npm

RUN mkdir -p ${INSTALL_DIR}
COPY ${BASE_CODE_FOLDER} ${INSTALL_DIR}
COPY config/cron/crontab /etc/cron.d/crontab
COPY build/php/env.php.sample ${INSTALL_DIR}/app/etc/env.php
RUN chown -R www-data:www-data ${INSTALL_DIR}

WORKDIR ${INSTALL_DIR}
USER www-data
