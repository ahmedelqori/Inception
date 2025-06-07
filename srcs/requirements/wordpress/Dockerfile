FROM alpine:3.22.0

RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-xml \
    php82-mbstring \
    php82-phar \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-json \
    php82-openssl \
    php82-zip \
    php82-gd \
    php82-tokenizer \
    wget \
    unzip \
    mysql-client

RUN ln -sf /usr/bin/php82 /usr/bin/php
RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php82/php.ini


COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh && mkdir -p /var/www/html 

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]