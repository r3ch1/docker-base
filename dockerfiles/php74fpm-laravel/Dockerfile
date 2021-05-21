FROM php:7.4-fpm

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    iputils-ping \
    net-tools \
    git \
    curl \
	openssl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libssl-dev \
    libicu-dev \
    libpq-dev

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update && apt-get install -y \
	php-xml \
	php-common \
	nginx \
    vim

RUN rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd

RUN docker-php-ext-install intl mbstring pcntl json pdo_mysql pdo_pgsql pgsql zip opcache

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# install cron
RUN apt-get update && apt-get -y install rsyslog

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

WORKDIR /var/www/

CMD ["/bin/bash", "-c", "nginx -g 'daemon off;'"]

COPY docker-entrypoint.sh /bin

ENTRYPOINT ["docker-entrypoint.sh"]
