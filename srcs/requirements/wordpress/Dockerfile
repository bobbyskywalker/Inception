FROM alpine:3.21

# Create logs directory early (writable by nobody)
RUN mkdir -p /var/www/wordpress/logs && \
    chown -R nobody:nobody /var/www/wordpress

# Install PHP 8.2 and necessary dependencies
RUN apk update && apk add --no-cache \
    php82 php82-fpm php82-mysqli php82-exif \
    php82-gd php82-curl php82-mbstring php82-opcache \
    php82-pecl-imagick php82-dom php82-session \
    php82-zlib php82-tokenizer php82-xml php82-common \
    curl tar less unzip bash \
    && mkdir -p /var/www/wordpress/logs \
    && chown -R nobody:nobody /var/www/wordpress \
    # ✅ Redirect PHP-FPM logs to Docker stderr
    && sed -i 's|^;*error_log = .*|error_log = /proc/self/fd/2|' /etc/php82/php-fpm.conf \
    && sed -i 's|^;*access.log = .*|access.log = /proc/self/fd/2|' /etc/php82/php-fpm.d/www.conf \
    && sed -i 's|^;*catch_workers_output = .*|catch_workers_output = yes|' /etc/php82/php-fpm.d/www.conf

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php82/php-fpm.d/www.conf

# Set WordPress version and working directory
ENV WP_VERSION=6.5.4
WORKDIR /var/www/wordpress

# Download and extract WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/wordpress-${WP_VERSION}.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

# Copy custom wp-config.php
COPY conf/wp-config.php /var/www/wordpress/wp-config.php

# Set final permissions
RUN chown -R nobody:nobody /var/www/wordpress

# Add setup script
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# Switch to non-root user
USER nobody

# Start PHP-FPM (this is PID 1)
CMD ["/setup.sh"]
