FROM alpine:3.22.0

RUN apk --no-cache add vsftpd bash

WORKDIR /app

COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

EXPOSE 21 21100-21110

CMD ["/script.sh"]
