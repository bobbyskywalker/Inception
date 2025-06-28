FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y php php7.4-fpm php7.4-mysql mariadb-client curl

# Configure PHP-FPM to listen on TCP
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# 🛠 Fix FPM startup error
RUN mkdir -p /run/php

# Install wp-cli globally
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./config/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 9000
CMD ["/script.sh"]
