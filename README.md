logzio-postgresql-logs
=========================

[Docker hub repository](https://hub.docker.com/r/logzio/postgresql-logs/)

This container ships your PostgreSQL logs to logz.io.
It ships its logs and PostgreSQL logs automatically to Logz.io via SSL so everything is encrypted.


***
## Usage (docker run)

```bash
docker run -d --name logzio-postgresql-logs -e LOGZIO_TOKEN=VALUE [-e LOGZIO_LISTENER=VALUE] \
          [-e POSTGRESQL_ERROR_LOG_FILE=VALUE] [-e POSTGRESQL_SLOW_LOG_FILE=VALUE] [-e POSTGRESQL_LOG_FILE=VALUE] \
          -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/postgresql \
          logzio/postgresql-logs:latest
```

#### Mandatory<br>
**LOGZIO_TOKEN** - Your [Logz.io App](https://app.logz.io) token, where you can find under "settings" in the web app.<br>

#### Optional<br>
**POSTGRESQL_ERROR_LOG_FILE** - Path to PostgreSQL error log. Default: /var/log/postgresql/error.log<br>
**POSTGRESQL_SLOW_LOG_FILE** - Path to PostgreSQL slow query log. Default: /var/log/postgresql/postgresql-slow.log<br>
**POSTGRESQL_LOG_FILE** - Path to PostgreSQL general log. Default: /var/log/postgresql/postgresql.log<br>
**LOGZIO_LISTENER** - Logzio listener host name. Default: listener.logz.io<br>


### Example
```bash
docker run -d \
  --name logzio-postgresql-logs \
  -e LOGZIO_TOKEN="YOUR_TOKEN" \
  -v /path/to/directory/logzio:/var/log/logzio \
  -v /path/to/directory/postgresql:/var/log/postgresql \
  --restart=always \
  logzio/postgresql-logs:latest
```

***
## RDS Usage (docker run)

```bash
docker run -d --name logzio-postgresql-logs -e LOGZIO_TOKEN=VALUE [-e LOGZIO_LISTENER=VALUE] \
          -e AWS_ACCESS_KEY=VALUE -e AWS_SECRET_KEY=VALUE -e RDS_IDENTIFIER=VALUE [-e AWS_REGION=VALUE] \
          [-e RDS_ERROR_LOG_FILE=VALUE] [-e RDS_SLOW_LOG_FILE=VALUE] [-e RDS_LOG_FILE=VALUE] \
          -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/postgresql \
          logzio/postgresql-logs:latest
```

#### Mandatory<br>
**LOGZIO_TOKEN** - Your [Logz.io App](https://app.logz.io) token, where you can find under "settings" in the web app.<br>
**AWS_ACCESS_KEY** - A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed)<br>
**AWS_SECRET_KEY** - A proper AMI credentials for RDS logs access (permissions for `download-db-log-file-portion` and `describe-db-log-files` are needed)<br>
**RDS_IDENTIFIER** - The RDS identifier of the host from which you want to read logs from.<br>

#### Optional<br>
**RDS_ERROR_LOG_FILE** - The path to the RDS error log file. Default: error/postgresql-error.log <br>
**RDS_SLOW_LOG_FILE** - The path to the RDS slow query log file. Default: slowquery/postgresql-slowquery.log <br>
**RDS_LOG_FILE** - The path to the RDS general log file. Default: general/postgresql-general.log <br>
**LOGZIO_LISTENER** - Logzio listener host name. Default: listener.logz.io <br>
**INTERVAL_SECONDS** - RDS Sync interval. Default: 60 seconds <br>
**AWS_REGION** - Default: us-east-1 <br>

### RDS Example
```bash
docker run -d \
  --name logzio-postgresql-logs \
  -e LOGZIO_TOKEN="YOUR_TOKEN" \
  -e AWS_ACCESS_KEY="YOUR_ACCESS_KEY" \
  -e AWS_SECRET_KEY="YOUR_SECRET_KEY" \
  -e AWS_REGION="YOUR_REGION" \
  -e RDS_IDENTIFIER="YOUR_DB_IDENTIFIER" \
  -e RDS_ERROR_LOG_FILE=error/postgresql-error.log \
  -e RDS_SLOW_LOG_FILE=slowquery/postgresql-slowquery.log \
  -e RDS_LOG_FILE=general/postgresql-general.log \
  -v /var/log/logzio:/var/log/logzio \
  -v /var/log/postgresql:/var/log/postgresql \
  logzio/postgresql-logs:latest
```

***
## Screenshots of dashboard from Logz.io
![alt text](https://images.contentful.com/50k90z6lk1k7/5M1Ayh1HxYuiY8soCgCCMc/fcaf1eb5fa28f98ec24a26fe96b222ac/postgresql_monitor_dash.png?h=250& "Logz.io Dashboard")
***
## About Logz.io
[Logz.io](https://logz.io) combines open source log analytics and behavioural learning intelligence to pinpoint what’s actually important
