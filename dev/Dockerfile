FROM pmprcoger/symfony:latest-prod

RUN apt-get update && apt-get install -y iproute2

# instala o xdebug
RUN if [ ! -z $http_proxy ]; then pear config-set http_proxy $http_proxy; fi && yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && if [ ! -z $http_proxy ]; then pear config-set http_proxy ""; fi \
    && docker-php-ext-enable xdebug

# instala certificado ssl no symfony
RUN symfony server:ca:install

# configuração do php
COPY files/php.ini/php.ini-development /usr/local/etc/php/php.ini
COPY files/Xdebug.ini /usr/local/etc/php/conf.d/xdebug.conf.ini

COPY files/cmd.sh /usr/bin/cmd.sh

RUN chmod +x /usr/bin/cmd.sh

COPY files/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

EXPOSE 443

RUN mkdir -p /srv/storage && chmod -R +w /srv/storage

VOLUME /srv/storage

ENTRYPOINT ["entrypoint.sh"]

CMD ["/usr/bin/cmd.sh"]
