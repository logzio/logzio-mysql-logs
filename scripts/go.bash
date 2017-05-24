#!/bin/bash

function cleanup() {
	kill -9 $(</run/sqlmonitor.pid)

	echo "Exiting..."
}

# Trap and do manual cleanup
trap cleanup HUP INT QUIT KILL TERM

# Setup dependencies
source ./base.sh

# get script arguments
parse_arguments $@

if [[ -z $LOGZIO_TOKEN ]]; then
    log "ERROR" "logz.io user token is required, exiting ..."
    echo "logz.io user token is required, exiting ..."
    exit 1
fi

if ! [[ -z $AWS_ACCESS_KEY && -z $AWS_SECRET_KEY ]]; then
  # default to the us-east-1 region if missing
  if [[ -z $AWS_REGION ]]; then
      export AWS_REGION='us-east-1'
    	log "INFO" "No AWS_REGION has not been specified, defaults to 'us-east-1'"
    	echo "INFO" "No AWS_REGION has not been specified, defaults to 'us-east-1'"
  fi

  # if present set the rds filebeat yaml config
  if [[ -f /root/filebeat-rds.ymal ]]; then
    cp -f /root/filebeat-rds.ymal $FILEBEAT_CONF
  fi

  # configure monitoring RDS logs
  configure_rds
fi

# print the env vars
env 

# run and monitor MySQL logs
run

# stop service
cleanup

