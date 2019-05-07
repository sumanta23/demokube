FROM ubuntu:18.04
MAINTAINER sumanta

LABEL description="Docker file for blog server"

RUN apt-get update

RUN apt-get -y install curl gnupg2


####Install node####
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
####################

RUN mkdir -p /var/www/logs/
RUN mkdir -p /usr/src/
WORKDIR /usr/src/
ADD app.tar.gz /usr/src/

RUN npm install --production

CMD ["node", "server.js"]


