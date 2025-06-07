FROM alpine:3.22.0

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/ael-qori.42.fr.key  \
    -out /etc/ssl/certs/ael-qori.42.fr.crt \
    -subj "/C=MA/CN=ael-qori.42.fr" > /dev/null 2>&1 \
    && mkdir -p /var/www/html 

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY tools/index.html /var/www/html
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
