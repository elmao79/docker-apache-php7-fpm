#
# Version: 1.0.1
#
FROM debian:buster
MAINTAINER Oscar Martin "oscar@omartin.es"

ENV REFRESHED_AT 2018-04-25

RUN apt-get update; apt-get install -y apache2 net-tools vim curl

ADD rootfs /

RUN apt-get install -y php7.2-fpm php7.2-mysql php7.2-pgsql php7.2-mbstring php7.2-curl php7.2-gd \
            php7.2-zip php7.2-sybase php7.2-opcache

RUN a2enmod proxy proxy_fcgi
RUN a2enconf php7.2-fpm

RUN mkdir -p /run/php

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80

RUN php-fpm7.2
CMD php-fpm7.2 && /usr/sbin/apache2ctl -D FOREGROUND
