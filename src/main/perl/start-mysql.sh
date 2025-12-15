#!/usr/bin/env bash
#-*- mode: sh; -*-

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
  -p 3306:3306 \
  -v $(pwd)/t/setup-mysql.sql:/docker-entrypoint-initdb.d/setup-mysql.sql \
  -v "$SOCKET_DIR":/var/run/mysqld \
  mysql:8.4
