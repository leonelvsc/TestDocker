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
    daemontools git curl nginx\
    php5-cli php5-json php5-fpm php5-intl php5-mcrypt php5-mysql mariadb-server mariadb-client

#Instalamos composer =D
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#Phpmyadmin

RUN apt-get install -y phpmyadmin
RUN apt-get install -y pwgen
RUN apt-get install -y inotify-tools

#ssh
RUN apt-get install -y openssh-server

#Configuramos ssh
RUN sed -i \
        -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
        -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
        -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
        -e 's/^#*\(UsePAM\) .*/\1 no/' \
        /etc/ssh/sshd_config

# Limpiamos la basura
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN echo "daemonize=no" > /etc/php5/fpm/pool.d/daemonize.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

#Configuraciones
ADD config/vhost.conf /etc/nginx/sites-enabled/default
ADD config/php.ini /etc/php5/fpm/php.ini
ADD config/php.ini /etc/php5/cli/php.ini
ADD config/my.cnf /etc/mysql/my.cnf

#Agrega carpetas de configuraciones
ADD scripts /scripts

#Configurar MariaDB
#Se crea para saber cuando corre por primera vez
RUN touch /firstrun

VOLUME ["/var/log/nginx/"]

ADD config/entrypoint.sh /usr/local/bin/entrypoint.sh

#Exponemos el puerto 80 para la web
EXPOSE 80
EXPOSE 22

#script que se ejecuta cada vez que se crea la vm
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]