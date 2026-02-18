#!/usr/bin/env bash
#-*- mode: sh; -*-

########################################################################
wait_for_mysql() {
########################################################################
    MYSQL_HOST=${MYSQL_HOST:-127.0.0.1}
    MYSQL_ROOT_USER=${MYSQL_ROOT_USER:-root}

    if test -z "$MYSQL_ROOT_PASSWORD"; then
     echo >&2 "ERROR: you must supply the root password!"
     false
    fi

    until mysql -u $MYSQL_ROOT_USER -h $MYSQL_HOST --password=$MYSQL_ROOT_PASSWORD -e "SELECT 1" >/dev/null 2>&1; do

        echo "Waiting for MySQL to be ready..."
        
        sleep 2
    done
}

set -oeu pipefail

MYSQL_ROOT_PASSWORD="${1:-flintstone}"
SOCKET_DIR="/tmp/mysqld"

if ! [[ -d "$SOCKET_DIR" ]]; then
    mkdir -p "$SOCKET_DIR"
    chmod 777 "$SOCKET_DIR"
fi

# Mount your setup script into the container's init folder
docker run --rm \
  --env MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -d \
  -p 3306:3306 \
  -v $(pwd)/t/setup-mysql.sql:/docker-entrypoint-initdb.d/setup-mysql.sql \
  -v "$SOCKET_DIR":/var/run/mysqld \
  mysql:8.4 >mysql-docker.id

wait_for_mysql
