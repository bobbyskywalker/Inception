FROM alpine:3.21

# Install MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

# Prepare required directories and permissions
RUN mkdir -p /run/mysqld /var/lib/mysql /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy config and SQL
COPY conf/custom.cnf /etc/my.cnf.d/custom.cnf
COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /var/lib/mysql

EXPOSE 3306

USER mysql

CMD ["/entrypoint.sh"]
