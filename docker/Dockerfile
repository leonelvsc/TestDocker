#Symfony2 development environment

FROM debian:7.5
MAINTAINER Leonel Franchelli <leonel.f@outlook.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
RUN echo "America/Argentina/Buenos_Aires" > /etc/timezone; dpkg-reconfigure tzdata

#Habilitamos los repos de la ultima version de php
RUN apt-get update
RUN apt-get install -y python-software-properties wget

RUN add-apt-repository 'deb http://packages.dotdeb.org wheezy-php55 all'
RUN echo 'deb-src http://packages.dotdeb.org wheezy-php55 all' >> '/etc/apt/sources.list'

RUN wget http://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg

#Repo de MariaDB
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://mirrors.fe.up.pt/pub/mariadb/repo/10.0/debian wheezy main'

#Actualizamos luego de agregar los repos
RUN apt-get update

RUN apt-get install -y \
    daemontools curl apache2 \
    php5-cli php5-json php5-fpm php5-intl php5-mysql mariadb-server mariadb-client phpmyadmin

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo "daemonize=no" > /etc/php5/fpm/pool.d/daemonize.conf
#RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Set environment variables
ENV APACHE_RUN_USER root
ENV APACHE_RUN_GROUP root
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C


#ADD vhost.conf /etc/nginx/sites-enabled/default
#ADD php.ini /etc/php5/fpm/php.ini
#ADD php.ini /etc/php5/cli/php.ini
#ADD my.cnf /etc/mysql/my.cnf

ADD services/ /srv/services

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]