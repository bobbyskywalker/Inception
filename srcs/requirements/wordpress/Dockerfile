# container's operating system
FROM debian:bullseye

# container's packages
RUN apt update -y
RUN apt upgrade -y
RUN apt install php -y
RUN apt install php7.4-fpm -y
RUN apt install php7.4-mysql -y
RUN apt install mariadb-client -y
RUN apt install curl -y

# container's config
RUN service php7.4-fpm start

WORKDIR /var/www/html

RUN sed -i -e 's/listen = .*/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Install WP-CLI globally as `wp`
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./config/script.sh /
RUN chmod 777 /script.sh

# port expose
EXPOSE 9000

# running the config script
CMD [ "/script.sh" ]
