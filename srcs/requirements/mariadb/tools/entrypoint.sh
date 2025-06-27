#!/bin/sh

echo "📦 Starting entrypoint..."

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "🛠 Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    echo "▶ Bootstrapping with init.sql..."
    mysqld --user=mysql --bootstrap < /docker-entrypoint-initdb.d/init.sql
    echo "✅ Bootstrapping done."
else
    echo "✅ Existing database detected, skipping init."
fi

echo "🚀 Starting MariaDB..."
exec mysqld --user=mysql --console
