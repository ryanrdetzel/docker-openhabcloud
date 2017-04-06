FROM ubuntu:16.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install nginx build-essential redis-server mongodb python git curl python-software-properties

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get -u install nodejs

RUN git clone https://github.com/openhab/openhab-cloud.git
WORKDIR /openhab-cloud
RUN npm install

COPY default /etc/nginx/sites-enabled/default
COPY config.json /openhab-cloud
COPY startupScript.sh /openhab-cloud
COPY renew_cron /openhab-cloud
RUN crontab /openhab-cloud/renew_cron

CMD ["/bin/bash", "/openhab-cloud/startupScript.sh"]
