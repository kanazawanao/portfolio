FROM node:18.17.0 AS builder

ARG ENV

WORKDIR /app

COPY ./package.json ./yarn.lock /app/
COPY ./src/ /app/src/

RUN yarn set version stable

# build
RUN cd /app && \
    yarn install && \
    yarn build:production && \
    rm -rf node_modules

FROM nginx:alpine

RUN apk add --no-cache bash

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist/. /usr/share/nginx/html/

CMD ["/bin/bash", "-c", "nginx -g 'daemon off;'"]