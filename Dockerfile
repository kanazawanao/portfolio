FROM node:18.17.0 AS builder

ARG ENV

WORKDIR /app

COPY ./ /app/

RUN yarn set version stable

# build
RUN cd /app && \
    yarn install && \
    yarn build && \
    rm -rf node_modules

FROM nginx:alpine

RUN apk add --no-cache bash

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist/. /usr/share/nginx/html/

CMD ["/bin/bash", "-c", "nginx -g 'daemon off;'"]