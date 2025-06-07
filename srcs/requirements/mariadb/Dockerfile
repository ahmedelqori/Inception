FROM alpine:3.22.0

RUN apk update && apk upgrade && apk add mariadb mariadb-client
        
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]