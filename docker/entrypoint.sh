#!/bin/bash -e
echo 'Bienvenidos al contenedor para PHP+NGINX+MARIADB'

echo 'Configurando MariaDB'

# Starts up MariaDB within the container.

# Stop on error
set -e

DATA_DIR=/data

if [[ -e /firstrun ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

wait_for_mysql_and_run_post_start_action() {
  # Wait for mysql to finish starting up first.
  while [[ ! -e /run/mysqld/mysqld.sock ]] ; do
      inotifywait -q -e create /run/mysqld/ >> /dev/null
  done

  post_start_action
}


if [ ! -d /var/www ]; then
    echo 'No application found in /var/www'
    exit 1;
fi

cd /var/www

if [ ! -d vendor ]; then
	echo 'Instalando symfony con composer'
    composer install
fi

if [ -f ./init.sh ]; then
    ./init.sh
fi

echo 'Configurando y habilitando servicios'

#Antes de iniciar mysql(maria)
pre_start_action 

exec service php5-fpm start & service nginx start & wait_for_mysql_and_run_post_start_action &

echo "Servicios web ok , iniciando MariaDB"
exec /usr/bin/mysqld_safe
