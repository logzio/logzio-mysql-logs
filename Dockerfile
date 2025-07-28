FROM ubuntu:24.04


RUN apt-get update
# RUN apt-get install -y python-pip
RUN apt-get install -y bc curl wget unzip less
# RUN pip install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-9.0.4-amd64.deb
RUN apt-get install -y ./filebeat-oss-9.0.4-amd64.deb

ENV LOGZIO_LOGS_DIR=/var/log/logzio
ENV MYSQL_LOGS_DIR=/var/log/mysql
ENV JAVA_HOME=/usr/
ENV AWS_CREDENTIAL_FILE=/root/.aws/credentials
ENV FILEBEAT_CONF=/etc/filebeat/filebeat.yml
ENV MYSQL_ERROR_LOG_FILE=""
ENV MYSQL_SLOW_LOG_FILE=""
ENV MYSQL_LOG_FILE=""

RUN wget https://raw.githubusercontent.com/logzio/public-certificates/master/AAACertificateServices.crt -P /root
RUN mkdir -p /etc/pki/tls/certs
RUN cp /root/AAACertificateServices.crt /etc/pki/tls/certs/

RUN mkdir -p $MYSQL_LOGS_DIR
RUN mkdir -p $LOGZIO_LOGS_DIR

ADD scripts/go.bash /root/
ADD scripts/utils.sh /root/
ADD scripts/base.sh /root/
ADD files/filebeat.yaml $FILEBEAT_CONF
ADD files/filebeat-rds.yaml /root/

# Make scripts executable
RUN chmod +x /root/go.bash /root/utils.sh /root/base.sh

WORKDIR /root
CMD ["/root/go.bash"]
		
