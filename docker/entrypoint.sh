#!/usr/bin/env bash
#-*- mode: sh; -*-

########################################################################
function init_sqlite_session {
########################################################################
    SQLITE_DIST_DIR=$(perl -MFile::ShareDir=dist_dir -e 'print dist_dir("BLM-Startup-SQLiteSession");')

    rm -f /var/www/bedrock/config.d/startup/mysql-session.xml

    if ! test -e /var/www/bedrock/config.d/startup/sqlite.xml; then
        echo "Installling sqlite.xml to /var/www/bedrock/config.d/startup" >&2
        cp $SQLITE_DIST_DIR/sqlite.xml /var/www/bedrock/config.d/startup
    fi

    dnky-config -r -i /var/www/bedrock/config/tagx.xml BEDROCK_SESSION_MANAGER SQLiteSession

    if ! test -e /var/lib/bedrock/bedrock.db; then
        echo "Creating new bedrock.db database and session table..." 2>&1
        create-sqlite-session-table
        chown www-data:www-data -R /var/lib/bedrock
    fi
}

########################################################################
function init_mysql_session {
########################################################################

    until mysql -h $MYSQL_HOST -u root --password="$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null; do
        echo "Waiting for MySQL to be ready..."
        sleep 2
    done

    if test -e /usr/local/share/setup.sql; then
        mysql -h $MYSQL_HOST -u root -p"$MYSQL_ROOT_PASSWORD" < /usr/local/share/setup.sql
    fi
}

########################################################################
# MAIN STARTS HERE
########################################################################

set -oex pipefail

export PATH=$APP_PATH/local/bin:$PATH

env

if [[ "$BEDROCK_SESSION_MANAGER" = mysql ]]; then
    init_mysql_session;
elif [[ "$BEDROCK_SESSION_MANAGER" = sqlite ]]; then
    init_sqlite_session;
else
    echo "WARNING: no session available"
fi

source /etc/os-release

if test "$ID" = "debian"; then
    source /etc/apache2/envvars
    sed -i -e 's|^ErrorLog.*$|ErrorLog /dev/stderr|' /etc/apache2/apache2.conf
else
    test -d /var/lib/bedrock || mkdir -p /var/lib/bedrock
    chown apache:apache -R /var/lib/bedrock
    sed -i -e 's|^ErrorLog.*$|ErrorLog /dev/stderr|' /etc/httpd/conf/httpd.conf
fi

exec "$@"
