FROM php:8.2-fpm-bullseye
 RUN apt-get -y update
 RUN apt-get dist-upgrade -y
 # Update, and install utilities and libraries needed for the php extensions installed
 RUN apt-get -y update && apt-get -y install \
     libicu-dev \
     libmemcached-dev \
     cron \
     default-libmysqlclient-dev \
     gettext \
     git \
     gnupg \
     imagemagick \
     libfreetype6-dev \
     libjpeg62-turbo-dev \
     libmagickwand-dev \
     libmcrypt-dev \
     libpng-dev \
     libsodium-dev \
     libzip-dev \
     msmtp \
     msmtp-mta \
     wget \
     zip \
     zlib1g-dev
 # Install all required extensions with builtin docker-php-ext-install
 RUN docker-php-ext-install \
     bcmath \
     calendar \
     gd \
     opcache \
     pcntl \
     pdo_mysql \
     sodium \
     zip \
     sockets
 RUN mkdir -p /usr/src/php/ext/redis
 #php redis install
 ENV PHPREDIS_VERSION 5.3.4
 RUN mkdir -p /usr/src/php/ext/redis \
     && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
     && echo 'redis' >> /usr/src/php-available-exts \
     && docker-php-ext-install redis
 RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/v3.2.0.tar.gz"
 RUN mkdir -p /usr/src/php/ext/memcached
 RUN echo 'memcached' >> /usr/src/php-available-exts \
     && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
     && docker-php-ext-configure memcached \
     && docker-php-ext-install memcached
 # Install various libraries only available through pecl
 RUN pecl install grpc && \
     docker-php-ext-enable grpc
     # pecl install mcrypt-1.0.2 && \
     # docker-php-ext-enable mcrypt && \
 RUN pecl install -n mcrypt
 RUN docker-php-ext-enable mcrypt
 RUN pecl install imagick-beta && \
     docker-php-ext-enable imagick
