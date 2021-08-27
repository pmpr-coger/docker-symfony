FROM php:8.0.10-fpm AS ext-amqp

ENV EXT_AMQP_VERSION=master

RUN docker-php-source extract \
    && apt-get update \
    && apt-get install -y git librabbitmq-dev librabbitmq4 \
    && git clone --branch $EXT_AMQP_VERSION --depth 1 https://github.com/php-amqp/php-amqp.git /usr/src/php/ext/amqp \
    && cd /usr/src/php/ext/amqp && git submodule update --init \
    && docker-php-ext-install amqp

RUN ls -al /usr/local/lib/php/extensions/

FROM php:8.0.10-fpm

WORKDIR /srv/app

RUN apt-get update

RUN apt-get install -y \
        git \
        openssl

# extensão zip para o php
RUN apt-get install -y \
        libzip-dev \
        zlib1g-dev \
        zip \ 
    && docker-php-ext-install zip 

# extensão intl para o php
RUN apt-get install -y \ 
        libicu-dev \
    && docker-php-ext-install intl

# extensão pdo postgres para o php
RUN apt-get install -y \ 
        libpq-dev \
    && docker-php-ext-install pdo_pgsql

# extensão php
RUN docker-php-ext-install opcache

# instala o composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --disable-tls && \
	mv composer.phar /usr/local/bin/composer

# instala o symfony globalmente
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv ~/.symfony/bin/symfony /usr/local/bin/symfony

# instala o xsl
RUN apt-get install -y libxslt-dev \
    && docker-php-ext-install xsl

# instala mbstring
RUN apt-get install -y libmcrypt-dev libonig-dev \
    && docker-php-ext-install mbstring 

# instala gd
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpnglite-dev \
    libpng-dev libwebp-dev libxpm-dev libfreetype6-dev zlib1g-dev libxml2-dev 
RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg --with-xpm
RUN docker-php-ext-install gd

# instala suporte ao RabbitMQ
RUN apt-get install -y librabbitmq4

COPY --from=ext-amqp /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini
COPY --from=ext-amqp /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/amqp.so

# instala suporte ao redis
RUN apt-get install -y libzstd-dev

RUN if [ ! -z $http_proxy ]; then pear config-set http_proxy $http_proxy; fi && yes | pecl install igbinary redis \
    && echo "extension=$(find /usr/local/lib/php/extensions/ -name igbinary.so)" > /usr/local/etc/php/conf.d/igbinary.ini \
    && echo "extension=$(find /usr/local/lib/php/extensions/ -name redis.so)" > /usr/local/etc/php/conf.d/redis.ini \
    && if [ ! -z $http_proxy ]; then pear config-set http_proxy ""; fi \
    && docker-php-ext-enable igbinary redis

RUN if [ ! -z $http_proxy ]; then pear config-set http_proxy $http_proxy; fi && yes | pecl install apcu \
    && echo "extension=$(find /usr/local/lib/php/extensions/ -name apcu.so)" > /usr/local/etc/php/conf.d/apcu.ini \
    && echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/apcu.ini \
    && echo "apc.enable=1" >> /usr/local/etc/php/conf.d/apcu.ini \
    && if [ ! -z $http_proxy ]; then pear config-set http_proxy ""; fi \
    && docker-php-ext-enable apcu

# configuração do php
COPY files/php.ini/php.ini-production /usr/local/etc/php/php.ini

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

EXPOSE 9000

CMD ["php-fpm"]
