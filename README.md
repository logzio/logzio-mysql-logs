logzio-mysql-logs
=========================

[Docker hub repository](https://hub.docker.com/r/logzio/mysql-logs/)


Deploy this integration to ship logs from your MySQL database (hosted on your system or on Amazon RDS) to your Logz.io account using a dedicated Docker container. This container will ship its own logs along with MySQL logs via SSL encrypted channels. 



#### On your host

##### Pull the Docker image of the MySQL logs shipper

```shell
docker pull logzio/mysql-logs
```

##### Run the Docker container


```bash
docker run -d --name logzio-mysql-logs -e LOGZIO_TOKEN=<<LOG-SHIPPING-TOKEN>> [-e LOGZIO_LISTENER=https://<<LISTENER-HOST>>:8071] \
          [-e MYSQL_ERROR_LOG_FILE=<<PATH-TO-ERROR-LOG-FILE>>] [-e MYSQL_SLOW_LOG_FILE=<<PATH-TO-SLOW-LOG-FILE>>] [-e MYSQL_LOG_FILE=<<PATH-TO-LOG-FILE>>] \
          -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/mysql \
          logzio/mysql-logs:latest
```

| Parameter | Description | Required/Default |
|---|---|---|
| LOGZIO_TOKEN | Your Logz.io account token. Replace `<<LOG-SHIPPING-TOKEN>>` with the token of the account you want to ship to. | Required |
| LOGZIO_LISTENER | Listener URL and port. Replace `<<LISTENER-HOST>>` with the host [for your region](https://docs.logz.io/user-guide/accounts/account-region.html#available-regions). For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe. | Required |
| MYSQL_ERROR_LOG_FILE | The path to MySQL error log. | Optional. `/var/log/mysql/error.log` |
| MYSQL_SLOW_LOG_FILE | The path to MySQL slow query log. | Optional. `/var/log/mysql/mysql-slow.log` |
| MYSQL_LOG_FILE | The path to MySQL general log. | Optional. `/var/log/mysql/mysql.log` |


Below is an example configuration for running the Docker container:

```bash
docker run -d \
  --name logzio-mysql-logs \
  -e LOGZIO_TOKEN="<<LOG-SHIPPING-TOKEN>>" \
  -v /path/to/directory/logzio:/var/log/logzio \
  -v /path/to/directory/mysql:/var/log/mysql \
  --restart=always \
  logzio/mysql-logs:latest
```


#### On Amazon RDS

##### Pull the Docker image of the MySQL logs shipper

```shell
docker pull logzio/mysql-logs
```

##### Run the Docker container

**Note:** If you're running this container on an AWS resource with the appropriate IAM Role permissions to access your RDS resource, you don't need to specify `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`.


```bash
docker run -d --name logzio-mysql-logs -e LOGZIO_TOKEN=<<LOG-SHIPPING-TOKEN>> [-e LOGZIO_LISTENER=https://<<LISTENER-HOST>>:8071] \
          -e RDS_IDENTIFIER=<<YOUR_DB_IDENTIFIER>> [-e AWS_ACCESS_KEY=<YOUR_ACCESS_KEY>>] [-e AWS_SECRET_KEY=<<YOUR_SECRET_KEY>>] [-e AWS_REGION=<<YOUR_REGION>>] \
          [-e RDS_ERROR_LOG_FILE=<<PATH-TO-ERROR-LOG-FILE>>] [-e RDS_SLOW_LOG_FILE=<<PATH-TO-SLOW-LOG-FILE>>] [-e RDS_LOG_FILE=<<PATH-TO-LOG-FILE>>] \
          -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/mysql \
          logzio/mysql-logs:latest
```

| Parameter | Description | Required/Default |
|---|---|---|
| LOGZIO_TOKEN | Your Logz.io account token. Replace `<<LOG-SHIPPING-TOKEN>>` with the token of the account you want to ship to. | Required |
| LOGZIO_LISTENER | Listener URL and port. Replace `<<LISTENER-HOST>>` with the host [for your region](https://docs.logz.io/user-guide/accounts/account-region.html#available-regions). For example, `listener.logz.io` if your account is hosted on AWS US East, or `listener-nl.logz.io` if hosted on Azure West Europe. | Required |
| RDS_IDENTIFIER | The RDS identifier of the host from which you want to read logs from. | Required |
| AWS_ACCESS_KEY | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). | Optional |
| AWS_SECRET_KEY | A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed). | Optional |
| AWS_REGION | Your AWS region | Optional. `us-east-1` |
| RDS_ERROR_LOG_FILE | The path to the RDS error log file. | Optional. `error/mysql-error.log` |
| RDS_SLOW_LOG_FILE | The path to the RDS slow query log file. | Optional. `slowquery/mysql-slowquery.log` |
| RDS_LOG_FILE | The path to the RDS general log file. | Optional. `general/mysql-general.log` |


Below is an example configuration for running the Docker container:

```bash
docker run -d \
  --name logzio-mysql-logs \
  -e LOGZIO_TOKEN=<<LOG-SHIPPING-TOKEN>> \
  -e AWS_ACCESS_KEY=<<YOUR_ACCESS_KEY>> \
  -e AWS_SECRET_KEY=<<YOUR_SECRET_KEY>> \
  -e AWS_REGION=<<YOUR_REGION>> \
  -e RDS_IDENTIFIER=<<YOUR_DB_IDENTIFIER>> \
  -e RDS_ERROR_LOG_FILE=error/mysql-error.log \
  -e RDS_SLOW_LOG_FILE=slowquery/mysql-slowquery.log \
  -e RDS_LOG_FILE=general/mysql-general.log \
  -v /var/log/logzio:/var/log/logzio \
  -v /var/log/mysql:/var/log/mysql \
  logzio/mysql-logs:latest
```



## Further deployments:

- [Deploying to Kubernetes](https://github.com/logzio/logzio-mysql-logs/tree/master/k8s)


## Screenshots of dashboard from Logz.io

![alt text](https://images.contentful.com/50k90z6lk1k7/5M1Ayh1HxYuiY8soCgCCMc/fcaf1eb5fa28f98ec24a26fe96b222ac/mysql_monitor_dash.png?h=250& "Logz.io Dashboard")

## About Logz.io

[Logz.io](https://logz.io) combines open source log analytics and behavioural learning intelligence to pinpoint what’s actually important

## Changelog:

- **1.0.0**:
  - Upgrade to Filebeat 8.3.2.
  - Allow usage with instance IAM Roles.
  - Add k8s deployment.
