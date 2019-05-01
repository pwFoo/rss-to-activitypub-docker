FROM node:alpine

RUN apk add --no-cache \
  python2 \
  make \
  g++

RUN mkdir /app

COPY . /app

RUN cd /app && \
  npm i

COPY docker/rootfs /

RUN chmod +x /init.sh

CMD ["/init.sh"]
