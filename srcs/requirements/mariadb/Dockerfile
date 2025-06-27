FROM alpine:3.21

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/custom.cnf /etc/my.cnf.d/custom.cnf
COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql

VOLUME /var/lib/mysql

EXPOSE 3306

USER mysql

CMD ["mysqld", "--user=mysql", "--console"]
