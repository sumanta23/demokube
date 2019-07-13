FROM node:10-alpine
MAINTAINER sumanta

LABEL description="Docker file for blog server"

RUN mkdir -p /var/www/logs/
RUN mkdir -p /usr/src/
WORKDIR /usr/src/

ADD package.json /usr/src/package.json
RUN npm install --production

ADD app.tar.gz /usr/src/

CMD ["node", "server.js"]


