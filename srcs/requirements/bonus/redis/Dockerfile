FROM alpine:3.22.0

RUN apk update && apk add --no-cache redis 

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode", "no", "--bind", "0.0.0.0"]