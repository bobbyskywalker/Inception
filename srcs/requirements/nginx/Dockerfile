# container's operating system
FROM debian:bullseye

# containers packages
RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx -y
RUN apt install openssl -y

# container's config
RUN adduser \
	--system \
	--no-create-home \
	--shell /bin/false \
	--group \
	--disabled-login www

RUN mkdir -p /etc/nginx/ssl

RUN openssl req \
 -x509 \
 -nodes \
 -days 365 \
 -newkey rsa:4096 \
 -keyout /etc/nginx/ssl/private.key \
 -out /etc/nginx/ssl/cert.crt \
 -subj "/C=PL/ST=Masovia/L=Warsaw/O=42Warsaw/OU=students/CN=agarbacz.42.fr/UID=agarbacz"

COPY ./config/default /etc/nginx/sites-available/default

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# port expose
EXPOSE 443

# service starting
CMD [ "nginx", "-g", "daemon off;" ]
