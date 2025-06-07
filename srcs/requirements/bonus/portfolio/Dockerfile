FROM alpine:3.22.0

RUN apk update && apk add --no-cache nodejs npm

WORKDIR /app

COPY app/ ./

RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
