FROM ubuntu:14.04

MAINTAINER Ofer Velich <ofer@logz.io>

RUN apt-get update
RUN apt-get install -y python-pip
RUN apt-get install -y bc curl wget unzip
RUN pip install awscli

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-amd64.deb
RUN dpkg -i filebeat-5.0.0-amd64.deb

ENV LOGZIO_LOGS_DIR /var/log/logzio
ENV POSTGRESQL_LOGS_DIR /var/log/postgresql
ENV JAVA_HOME /usr/
ENV AWS_CREDENTIAL_FILE /root/.aws/credentials
ENV FILEBEAT_CONF /etc/filebeat/filebeat.yml
ENV POSTGRESQL_ERROR_LOG_FILE ""
ENV POSTGRESQLL_SLOW_LOG_FILE ""
ENV POSTGRESQL_LOG_FILE ""

RUN wget https://raw.githubusercontent.com/logzio/public-certificates/master/COMODORSADomainValidationSecureServerCA.crt -P /root
RUN mkdir -p /etc/pki/tls/certs
RUN cp /root/COMODORSADomainValidationSecureServerCA.crt /etc/pki/tls/certs/

RUN mkdir -p $POSTGRESQL_LOGS_DIR
RUN mkdir -p $LOGZIO_LOGS_DIR

ADD scripts/go.bash /root/
ADD scripts/utils.sh /root/
ADD scripts/base.sh /root/
ADD files/filebeat.ymal $FILEBEAT_CONF
ADD files/filebeat-rds.ymal /root/

WORKDIR /root
CMD "/root/go.bash"
