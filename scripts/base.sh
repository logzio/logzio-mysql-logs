#!/bin/bash


# PostgreSQL host creds defaults
: ${POSTGRESQL_HOST:=""}
: ${POSTGRESQL_USER:=""}
: ${POSTGRESQL_PASS:=""}

# running checks interval, default to 60 seconds
: ${INTERVAL_SECONDS:=60}

# logging level (debug, info and error), default to info
export LOG_LEVEL=${LOG_LEVEL:=2}

# logzio log files
export LOG_FILE=$LOGZIO_LOGS_DIR/logzio.log
export ERROR_LOG_FILE=$LOGZIO_LOGS_DIR/logzio-error.log

export LOGZIO_LISTENER=${LOGZIO_LISTENER:="listener.logz.io"}

# pid files to prevent overrides
export PID_DIR=/run/logzio
export PID_FILE=$PID_DIR/sql-logs.pid

# PostgreSQL log files defaults
if [[ -z $POSTGRESQL_ERROR_LOG_FILE ]]; then
    export POSTGRESQL_ERROR_LOG_FILE=$POSTGRESQL_LOGS_DIR/error.log
fi

if [[ -z $POSTGRESQL_LOG_FILE ]]; then
    export POSTGRESQL_LOG_FILE=$POSTGRESQL_LOGS_DIR/postgresql.log
fi

if [[ -z $POSTGRESQL_SLOW_LOG_FILE ]]; then
    export POSTGRESQL_SLOW_LOG_FILE=$POSTGRESQL_LOGS_DIR/postgresql-slow.log
fi

# Setup dependencies
source ./utils.sh

# ----------------------------------------
# useage
# ----------------------------------------
function usage {
    echo
    echo "Usage:"
	echo docker run -d --name logzio-postgresql-logs -e LOGZIO_TOKEN=VALUE [-e LOGZIO_LISTENER=VALUE] \
                    [-e POSTGRESQL_ERROR_LOG_FILE=VALUE] [-e POSTGRESQL_SLOW_LOG_FILE=VALUE] [-e POSTGRESQL_LOG_FILE=VALUE] \
                    -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/postgresql \
                    logzio/postgresql-logs:latest
	echo
    echo
    echo "RDS Usage:"
    echo docker run -d --name logzio-postgresql-logs -e LOGZIO_TOKEN=VALUE [-e LOGZIO_LISTENER=VALUE] \
                    -e AWS_ACCESS_KEY=VALUE -e AWS_SECRET_KEY=VALUE -e AWS_REGION=VALUE -e RDS_IDENTIFIER=VALUE \
                    [-e RDS_ERROR_LOG_FILE=VALUE] [-e RDS_SLOW_LOG_FILE=VALUE] [-e RDS_LOG_FILE=VALUE] \
                    -v path_to_directory:/var/log/logzio -v path_to_directory:/var/log/postgresql \
                    logzio/postgresql-logs:latest
    echo
    exit $1
}

# ----------------------------------------
# script arguments
# ----------------------------------------
function parse_arguments {
    while :; do
        case $1 in
            --help)
                usage 0
                ;;

            -v|--verbose)
                LOG_LEVEL=3
                log "INFO" "Log level is set to debug."
                ;;

            --) # End of all options.
                shift
                break
                ;;
            *)  # Default case: If no more options then break out of the loop.
                break
        esac

        shift
    done
}


# ----------------------------------------
# start watching rds log files and write it
# to files so rsyslog can monitor then
# ----------------------------------------
function configure_rds() {
    mkdir -p /root/.aws
    echo "[default]" > $AWS_CREDENTIAL_FILE
    echo "region = $AWS_REGION" >> $AWS_CREDENTIAL_FILE
    echo "aws_secret_access_key = $AWS_SECRET_KEY" >> $AWS_CREDENTIAL_FILE
    echo "aws_access_key_id = $AWS_ACCESS_KEY" >> $AWS_CREDENTIAL_FILE

    # if the describe log file fails, we will exit with error (and log it)
    execute aws rds describe-db-log-files --db-instance-identifier $RDS_IDENTIFIER

    local monitoring=""

    # start watching each configured log file
    if [[ ! -z $RDS_LOG_FILE ]]; then
        touch $POSTGRESQL_LOG_FILE
        monitoring="$RDS_LOG_FILE"
    fi

    if [[ ! -z $RDS_SLOW_LOG_FILE ]]; then
        touch $POSTGRESQL_SLOW_LOG_FILE
        monitoring="$monitoring $RDS_SLOW_LOG_FILE"
    fi

    if [[ ! -z $RDS_ERROR_LOG_FILE ]]; then
        touch $POSTGRESQL_ERROR_LOG_FILE
        monitoring="$monitoring $RDS_ERROR_LOG_FILE"
    fi

    SHIP_RDS="true"
    log "INFO" "Monitor RDS files: $monitoring"
}

# ----------------------------------------
# Sync RDS log files
# ----------------------------------------
function sync_rds() {
    HOUR=$(date +%Y-%m-%d-%H)
    # if the user configured the rds general log file ... sync it
    if [[ ! -z $RDS_LOG_FILE ]]; then
        aws rds download-db-log-file-portion --db-instance-identifier $RDS_IDENTIFIER --output text --log-file-name $RDS_LOG_FILE.$HOUR > /tmp/postgresql.log 2>> $ERROR_LOG_FILE

        HOURLY_POSTGRESQL_LOG_FILE="$POSTGRESQL_LOG_FILE-$HOUR"

        diff $HOURLY_POSTGRESQL_LOG_FILE /tmp/postgresql.log | grep '>' | cut -c 3- >> $HOURLY_POSTGRESQL_LOG_FILE
    fi

    # if the user configured the rds slow log file ... sync it
    if [[ ! -z $RDS_SLOW_LOG_FILE ]]; then
        aws rds download-db-log-file-portion --db-instance-identifier $RDS_IDENTIFIER --output text --log-file-name $RDS_SLOW_LOG_FILE.$HOUR > /tmp/postgresql-slow.log 2>> $ERROR_LOG_FILE

        HOURLY_POSTGRESQL_SLOW_LOG_FILE="$POSTGRESQL_SLOW_LOG_FILE-$HOUR"

        diff $HOURLY_POSTGRESQL_SLOW_LOG_FILE /tmp/postgresql-slow.log | grep '>' | cut -c 3- >> $HOURLY_POSTGRESQL_SLOW_LOG_FILE
    fi

    # if the user configured the rds error log file ... sync it
    if [[ ! -z $RDS_ERROR_LOG_FILE ]]; then
        aws rds download-db-log-file-portion --db-instance-identifier $RDS_IDENTIFIER --output text --log-file-name $RDS_ERROR_LOG_FILE.$HOUR > /tmp/error.log 2>> $ERROR_LOG_FILE

        HOURLY_POSTGRESQL_ERROR_LOG_FILE="$POSTGRESQL_ERROR_LOG_FILE-$HOUR"

        diff $HOURLY_POSTGRESQL_ERROR_LOG_FILE /tmp/error.log | grep '>' | cut -c 3- >> $HOURLY_POSTGRESQL_ERROR_LOG_FILE
    fi

    # delete old files
    find $POSTGRESQL_LOGS_DIR -type f -mmin +3 -delete
}


# ----------------------------------------
# Restart Filebeat
# ----------------------------------------
function restart_filebeat() {
    log "INFO" "POSTGRESQL_ERROR_LOG_FILE: $POSTGRESQL_ERROR_LOG_FILE"
    log "INFO" "POSTGRESQL_SLOW_LOG_FILE: $POSTGRESQL_SLOW_LOG_FILE"
    log "INFO" "POSTGRESQL_LOG_FILE: $POSTGRESQL_LOG_FILE"
    log "INFO" "LOGZIO_TOKEN: $LOGZIO_TOKEN"
    log "INFO" "LOGZIO_LISTENER: $LOGZIO_LISTENER"

    execute /etc/init.d/filebeat start
}

# ----------------------------------------
# Run
# ----------------------------------------
function run() {
    # start file beat
    restart_filebeat

    execute rm -rf $PID_DIR
    execute mkdir -p $PID_DIR

    while true; do
        if [[ -f $PID_FILE ]]; then
            log "DEBUG" "PID File exist .... "

            sleep $INTERVAL_SECONDS
        else
            log "DEBUG" "Running .... "

            # write the current session's PID to file
            echo $$ >> $PID_FILE

            if [[ $SHIP_RDS == "true" ]]; then
                # sync rds lo files
                sync_rds
            fi

            sleep $INTERVAL_SECONDS

            execute rm -f $PID_FILE
        fi
    done
}
