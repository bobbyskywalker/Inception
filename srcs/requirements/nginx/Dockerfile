FROM alpine:3.21

RUN apk update && apk add --no-cache nginx openssl

# tls certs dir
RUN mkdir -p /etc/nginx/ssl

# config and certs copy into container
COPY conf/proxy_params /etc/nginx/proxy_params
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl/nginx.crt /etc/nginx/ssl/nginx.crt
COPY tools/ssl/nginx.key /etc/nginx/ssl/nginx.key

# port
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
