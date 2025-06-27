#!/bin/sh

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "🛠 Initializing MariaDB system tables..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

    echo "▶ Bootstrapping with init.sql..."
    mysqld --user=mysql --bootstrap < /docker-entrypoint-initdb.d/init.sql
else
    echo "✅ Existing database detected, skipping init."
fi

exec mysqld --user=mysql --console
