FROM node:9
RUN mkdir -p /app
WORKDIR /app
ADD . /app

RUN apt-get update -qq && apt-get -y install nodejs build-essential git
RUN npm install -g yarn && \
    chmod +x /usr/local/bin/yarn && \
    yarn install --network-timeout 1000000

RUN chmod +rwx /app/deployment/init.sh
RUN chmod +rwx /app/deployment/init-payout.sh

EXPOSE 8650 8444 8443 3306 8650
