#
# Version: 1.0.1
#
FROM debian:rc-buggy
MAINTAINER Oscar Martin "oscar@omartin.es"

ENV REFRESHED_AT 2018-04-25

RUN apt-get update; apt-get install -y apt-utils apache2 net-tools
RUN apt-get install -y curl git zip unzip vim locales software-properties-common

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN /usr/sbin/update-locale

ADD rootfs /

RUN apt-get install -y php7.2-fpm

RUN a2enmod proxy proxy_fcgi
COPY php7.1-fpm.conf /etc/apache2/conf-available/php7.1-fpm.conf
RUN a2enconf php7.1-fpm

RUN mkdir -p /run/php

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stdout /var/log/apache2/other_vhosts_access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80

RUN php-fpm7.2
CMD php-fpm7.2 && /usr/sbin/apache2ctl -D FOREGROUND
